import { Equal, FindOptionsWhere } from 'typeorm';

import { AppDataSource } from '../orm/data-source';

import { AppartementEntity } from '../orm/entities/appartement.entity';

const appartementRespository = AppDataSource.getRepository(AppartementEntity);

// export const createCheckin = async (input: Partial<ChekinEntity>) => {
//   return await checkinRespository.save(checkinRespository.create(input));
// };
export const createAppartement = async (input: Partial<AppartementEntity>) => {
  return await appartementRespository.save(appartementRespository.create(input));
};

export const saveAppartement = async (appartement: AppartementEntity) => {
  return await appartementRespository.save(appartement);
};

export const findAppartementsByUser = async (userId: number, relations = []) => {
  return await appartementRespository.find({
    where: { user: Equal(userId) },
    relations: relations,
  });
};
export const findAppartements = async () => {
  return await appartementRespository.find({

  });
};

export const deleteAppartementById = async (id) => {
  return await appartementRespository.delete({ id: Equal(id) });
};

export const findAppartementById = async (
appartementId: number,
  userId: number,
  relations = []
) => {
  return await appartementRespository.findOne({
    where: { id: Equal(appartementId), user: Equal(userId) },
    relations: relations,
  });
};

export const findAppartementByIdAndUser = async (
  appartementId: number,
  userId: number,
  relations = []
) => {
  return await appartementRespository.findOne({
    where: { id: Equal(appartementId), user: Equal(userId) },
    relations: relations,
  });
};
