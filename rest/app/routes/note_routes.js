var ObjectID = require('mongodb').ObjectID;
module.exports = function(app, db) {

  app.get('/token/:id', (req, res) => {
    const id = req.params.id;
    const details = { '_id': new ObjectID(id) };
    db.collection('token').findOne(details, (err, item) => {
      if (err) {
        res.send({'error':'An error has occurred'});
      } else {
        res.send(item);
      } 
    });
  });
    app.delete('/token/:id', (req, res) => {
    const id = req.params.id;
    const details = { '_id': new ObjectID(id) };
    db.collection('token').remove(details, (err, item) => {
      if (err) {
        res.send({'error':'An error has occurred'});
      } else {
        res.send('Note ' + id + ' deleted!');
      } 
    });
  });
      app.put ('/token/:id', (req, res) => {
    const id = req.params.id;
    const details = { '_id': new ObjectID(id) };
    if (Object.keys(req.body) == 'tokenDevice'){
    var note = { tokenDevice: req.body.tokenDevice };
    };
    if (Object.keys(req.body) == 'total'){
    var note = { total: req.body.total };
    };
    if (Object.keys(req.body) == 'max'){
    var note = { max: req.body.max };
    };
    db.collection('token').update(details, note, (err, result) => {
      if (err) {
          res.send({'error':'An error has occurred'});
      } else {
          res.send(note);
      } 
    });
  });
           app.post('/token/:id', (req, res) => {
    const id = req.params.id;
    const details = { '_id': new ObjectID(id) };
    var note = { $addToSet:{ tokenDevice: req.body.tokenDevice }};
    db.collection('token').update(details, note, (err, result) => {
      if (err) { 
        res.send({ 'error': 'An error has occurred' }); 
      } else {
        res.send(note);
      }
    });
  });
};
