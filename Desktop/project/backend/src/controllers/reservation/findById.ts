import { Request, Response, NextFunction } from 'express';
import { findUserById } from '../../services/user.service';
import { findCheckinById, findCheckinByIdAndUser } from '../../services/checkin.service';

export const findById = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const { id } = req.jwtPayload;
  const checkId = req.params.id;


    try {
        const check = await findCheckinByIdAndUser(Number(checkId), id);

      return res.customSuccess(
        200,
        'List of checkins.',
        { check: check },
        true
      );
    } catch (err) {
      return res.customSuccess(200, `check not found`, {}, false);
    }
  
};
