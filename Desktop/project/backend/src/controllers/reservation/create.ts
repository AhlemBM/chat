import { Request, Response, NextFunction } from 'express';


import { findUserById } from '../../services/user.service';
import { createCheckin, saveCheckin } from '../../services/checkin.service';
import { stringify } from 'querystring';

export const create = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {

  const { id } = req.jwtPayload;
  const { commission, frais_menage } = req.body;

  try {
    try {
      const currentUser = await findUserById(id);

      
      const newCheckin = await createCheckin({

        user: currentUser,
        commission,
        frais_menage,

        
      });

      await saveCheckin(newCheckin);
      return res.customSuccess(
        200,
        'reservation successfully created.',
        { checkin: newCheckin },
        true
      );
    } catch (err) {
      console.log("$$$$$$$$$$$$$");
      return res.customSuccess(200, `reservation can't be created`, {}, false);
    }
  } catch (err) {
    
    return res.customSuccess(200, `reservation can't be created`, {}, false);
  }
};
