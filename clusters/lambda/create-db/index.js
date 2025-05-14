import { GetSecretValueCommand, SecretsManagerClient } from '@aws-sdk/client-secrets-manager';
import awsCaBundle from 'aws-ssl-profiles';
import { Client } from 'pg';

const getSecretValue = async (SecretId) => {
    try {
        const client = new SecretsManagerClient();

        const response = await client.send(
            new GetSecretValueCommand({
                SecretId: SecretId,
            }),
        );

        return JSON.parse(response.SecretString);
    } catch (error) {
        console.error(error.message);
        return null;
    }
};

export const handler = async ({ database }, context) => {
    const credentials = await getSecretValue(process.env.SECRET_NAME);

    if (!credentials) {
        return context.logStreamName;
    };

    const client = new Client({
        host: credentials.host,
        port: credentials.port,
        user: credentials.username,
        password: credentials.password,
        ssl: awsCaBundle,
    });

    if (!client) {
        return context.logStreamName;
    };

    try {
        await client.connect();

        await client.query(`CREATE DATABASE "${database}"`);

        console.info(`Successfully created "${database}" database.`);
    } catch (error) {
        console.error(error.message);
    } finally {
        client.end();

        return context.logStreamName;
    }
};
