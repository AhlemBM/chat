import { Router } from 'express';
import { check } from 'prettier';

import { create, deleteCheckin, findById,findAll, update } from '../../controllers/reservation';
import { checkJwt } from '../../middleware/checkJwt';
import {
  validatorCreate,
  validatorUpdate,
} from '../../middleware/validation/reservation';


const router = Router();

router.post('/create', [checkJwt, validatorCreate], create);
router.get('/getAll', [checkJwt], findAll);
router.delete('/delete/:id', [checkJwt], deleteCheckin);
router.put('/update/:id', [checkJwt, validatorUpdate], update);
router.get('/find/:id', [checkJwt], findById);
export default router;
