import yup from 'yup';

export const schemas = {
    id: () =>
        yup
            .string()
            .matches(/^[a-zA-Z0-9]{17}$/)
            .label('Id'),
};
