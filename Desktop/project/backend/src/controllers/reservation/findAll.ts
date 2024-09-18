import { Request, Response, NextFunction } from 'express';
import { findUserById } from '../../services/user.service';
import { findCheckinById, findCheckinByIdAndUser, findCheckinsByUser } from '../../services/checkin.service';

export const findAll = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const { id } = req.jwtPayload;



    try {
        const checkins = await findCheckinsByUser( id);
        

      return res.customSuccess(
        200,
        'List of checkins.',
        { checkins: checkins },
        true
      );
    } catch (err) {
      return res.customSuccess(200, `checkins not found`, {}, false);
    }
  
};
