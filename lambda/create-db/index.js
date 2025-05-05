import { GetSecretValueCommand, SecretsManagerClient } from '@aws-sdk/client-secrets-manager';
import { awsCaBundle } from 'aws-ssl-profiles';
import postgres from 'postgres';

const getSecretValue = async (SecretId) => {
    const client = new SecretsManagerClient();
    const response = await client.send(
        new GetSecretValueCommand({
            SecretId: SecretId,
        }),
    );

    try {
        return JSON.parse(response.SecretString);
    } catch (err) {
        console.error('Error getting secret value', err);
        throw new Error(`Error getting secret value: ${err.message}`);
    }
};


export const handler = async ({ database }) => {
    const sql = postgres({
        ...await getSecretValue(process.env.SECRET_NAME),
        ssl: awsCaBundle,
    });

    const query = await sql` CREATE DATABASE ${sql(database)}`;

    return query;
};
