import { Request, Response, NextFunction } from 'express';

import {
    deleteCheckinById,
    findCheckinById,
    findCheckinByIdAndUser,
} from '../../services/checkin.service';

export const deleteCheckin = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const CheckId = req.params.id;
  const { id } = req.jwtPayload;
    try {
    try {
        
      const checkin = await findCheckinByIdAndUser(Number(CheckId), id);
    
      if (!checkin) {
        return res.customSuccess(200, 'checkin not found', {}, false);
      }

      await deleteCheckinById(CheckId);
    
      return res.customSuccess(200, 'checkin successfully deleted.', true, true);
    } catch (err) {
      
      return res.customSuccess(200, `checkin can't be deleted`, {}, false);
    }
  } catch (err) {
    return res.customSuccess(200, `checkin can't be deleted`, {}, false);
  }
};
