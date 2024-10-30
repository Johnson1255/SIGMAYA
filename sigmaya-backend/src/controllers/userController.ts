import { Request, Response } from 'express';
import User, { IUser } from '../models/User';

export const getUsers = async (req: Request, res: Response): Promise<void> => {
  try {
    const users: IUser[] = await User.find();
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching users' });
  }
};

export const createUser = async (req: Request, res: Response): Promise<void> => {
  try {
    const user: IUser = new User(req.body);
    await user.save();
    res.status(201).json(user);
  } catch (error) {
    res.status(400).json({ message: 'Error creating user' });
  }
};