
import jwt from "jsonwebtoken";

export const createJwtToken = (payload: any) => {
    return jwt.sign(payload, process.env.JWT_SECRET as string, {
        expiresIn: "10d",
    });
}