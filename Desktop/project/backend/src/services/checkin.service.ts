import { Equal, FindOptionsWhere } from 'typeorm';

import { AppDataSource } from '../orm/data-source';
import { ChekinEntity } from '../orm/entities/checkin.entity';

const checkinRespository = AppDataSource.getRepository(ChekinEntity);

export const createCheckin = async (input: Partial<ChekinEntity>) => {
  return await checkinRespository.save(checkinRespository.create(input));
};

export const saveCheckin = async (checkin: ChekinEntity) => {
  return await checkinRespository.save(checkin);
};

export const findCheckinsByUser = async (userId: number, relations = []) => {
  return await checkinRespository.find({
    where: { user: Equal(userId) },
    relations: relations,
  });
};

export const findCheckinByIdAndUser = async (
  checkId: number,
  userId: number,
  relations = []
) => {
  return await checkinRespository.findOne({
    where: { id: Equal(checkId), user: Equal(userId) },
    relations: relations,
  });
};

export const deleteCheckinById = async (id) => {
  return await checkinRespository.delete({ id: Equal(id) });
};

export const findCheckinById = async (
  checkId: number,
  userId: number,
  relations = []
) => {
  return await checkinRespository.findOne({
    where: { id: Equal(checkId), user: Equal(userId) },
    relations: relations,
  });
};
