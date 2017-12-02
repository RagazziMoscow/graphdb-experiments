var chalk = require('chalk');
var async = require('async');

const connection = require('./database')['dev'];

const Client = require('pg').Client;
const client = new Client(connection);

var objectsTaksk = {
  clearTable: (done) => {
    client.query('DELETE from \"nir-object\" CASCADE', (err) => {
      if (err) done(err);
      console.log(chalk.green('OBJECTS TABLE...CLEARED...OK'));
      done(null);
    });
  },
  fillTable: (done) => {

    client.query('SELECT fill_objects(10000)', (err, res) => {
      if (err) done(err);
      console.log(chalk.green('OBJECTS TABLE...FILLED...OK'));
      done(null);
    });
  }
};

var linksTasks = {
  fillTable: (done) => {
    client.query('SELECT fill_links(10000)', (err) => {
      if (err) done(err);
      console.log(chalk.green('LINKS TABLE...FILLED...OK'));
      done(null);
    });
  }
};


var typesTasks = {
  intTable: (done) => {
    client.query('SELECT fill_int_table(50, 100)', (err) => {
      if (err) done(err);
      console.log(chalk.green('INT TABLE...FILLED...OK'));
      done(null);
    });
  },
  stringTable: (done) => {
    client.query('SELECT fill_string_table(7);', (err) => {
      if (err) done(err);
      console.log(chalk.green('STRING TABLE...FILLED...OK'));
      done(null);
    });
  },
  realTable: (done) => {
    client.query('SELECT fill_real_table(50,100)', (err) => {
      if (err) done(err);
      console.log(chalk.green('REAL TABLE...FILLED...OK'));
      done(null);
    });
  },
  binarytable: (done) => {
    client.query('SELECT fill_binary_table(6)', (err) => {
      if (err) done(err);
      console.log(chalk.green('BINARY TABLE...FILLED...OK'));
      done(null);
    });
  },
  datetimeTable: (done) => {
    client.query('SELECT fill_datetime_table(\'2012-05-05 00:00:00\', \'2016-06-06 00:00:00\');', (err) => {
      if (err) done(err);
      console.log(chalk.green('DATETIME TABLE...FILLED...OK'));
      done(null);
    });
  }
};

client.connect((err) => {
  if (err) console.log(chalk.red('CONNECTION ERROR...', err));

  if (!err) {
    console.log(chalk.yellow('CONNECTED...OK'));
    async.series([
      (done) => {
        // Заполнение объектов
        async.series(objectsTaksk, (err, results) => {
          if (err) done(err);
          done(null);
        });
      },
      (done) => {
        // Заполнение связей
        async.series(linksTasks, (err, results) => {
          if (err) done(err);
          done(null);
        });
      }
    ], (err, results) => {
      if (err) console.log(chalk.red(err));

      if (!err) {

        // Заполнение таблиц со всеми типами(парпллельно)
        async.parallel(typesTasks, (err, results) => {
          if (err) console.log(chalk.red(err));

          client.end();
          if (!err) console.log(chalk.green('DATABASE ARE FILLED...Done...OK'));
        });
      }
    });

  }

});