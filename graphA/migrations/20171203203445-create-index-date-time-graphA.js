'use strict';

var dbm;
var type;
var seed;

/**
  * We receive the dbmigrate dependency from dbmigrate initially.
  * This enables us to not have to rely on NODE_PATH.
  */
exports.setup = function(options, seedLink) {
  dbm = options.dbmigrate;
  type = dbm.dataType;
  seed = seedLink;
};

exports.up = function(db) {
  return db.addIndex('date-time', 'date-time_index_link_id', ['link_id'], true);
};

exports.down = function(db) {
  return db.removeIndex('date-time', 'date-time_index_link_id');
};

exports._meta = {
  "version": 1
};
