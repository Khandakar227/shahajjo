import admin from "./fireAdmin";

export const sendNotification = async (token: string, title: string, body: string) => {
    const message = {
        notification: {
            title,
            body
        },
        token
    };

    try {
        const response = await admin.messaging().send(message);
        return response;
    } catch (error) {
        console.log('Error sending message:', error);
    }
}