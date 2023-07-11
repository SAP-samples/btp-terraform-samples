'use strict';

/**
 * Wraps an optional callback.
 */
module.exports = function callback(cb) {
  return function callback() {
    if (cb) {
      cb.apply(undefined, arguments);
    } else if (arguments[0]) {
      let error = arguments[0];
      throw error;
    }
  };
};
