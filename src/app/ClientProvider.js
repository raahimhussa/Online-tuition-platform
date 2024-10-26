
'use client';

import { Provider } from 'react-redux';
import PropTypes from 'prop-types';

import store from './store/store';

export default function ClientProvider({ children }) {
    return <Provider store={store}>{children}</Provider>;
}

ClientProvider.propTypes = {
    children: PropTypes.node.isRequired,
};
