import yup from 'yup';

import { schemas } from '/core/schemas';

export const itemSchema = () =>
    yup.object().shape({
        _id: schemas.id(),
        count: yup
            .number()
            .default(0)
            .required(),
    });
