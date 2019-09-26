import yup from 'yup';

import { Items } from '/items/collections';
import { itemSchema } from '/items/schemas';

if (Items.find().count() === 0) {
    const newItem = itemSchema().validateSync({ count: 0 });

    new Array(36).fill(null).forEach(() => Items.insert(newItem));
}
