import { Signer } from "@aws-sdk/rds-signer";
import awsCaBundle from 'aws-ssl-profiles';
import { Client } from 'pg';

async function createAuthToken() {
    const signer = new Signer({
        hostname: process.env.DB_HOST,
        port: process.env.DB_PORT,
        username: process.env.DB_USERNAME,
        region: process.env.AWS_REGION,
    });

    return await signer.getAuthToken();
}

function success(message) {
    return {
        success: true,
        message: message,
    };
}

function error(message, context = null) {
    return {
        success: false,
        error: message,
        context: context,
    };
}

export const handler = async ({ database }) => {
      const token = await createAuthToken();

      const client = new Client({
          host: process.env.DB_HOST,
          port: process.env.DB_PORT,
          user: process.env.DB_USERNAME,
          password: token,
          ssl: awsCaBundle,
      });

      const query = {
          text: `CREATE DATABASE $1`,
          values: [database]
      };

      return client.connect()
          .then(() => {
              console.log(`Connected to ${client.host}:${client.port}`);

              client.query(query, (err, res) => {
                  if (err) {
                      return error(`Error creating database ${database}`, err);
                  } else {
                      return success(`Database ${database} created successfully.`);
                  }
              })
              .then(() => {
                  client.end();
              });
          })
          .catch((err) => {
             return error(`Error connecting to ${client.host}:${client.port}`, err);
          });
};
