const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.updateID = functions.https.onCall((data, context) => {

    var adminsList = data.admins;
    var id = data.id;
    var newID = data.newID;

    adminsList.forEach(admin => {
        var ref = firebase.database().ref('/Users/' + admin + '/AdminTeams');
        ref.child(id).remove().then(() =>{
            ref.update({
                [newID] : " "
            })
            return "FINISH"
        });
    });
    return firebase.database().ref('/TeamSportfolios/' + id).remove();

});

exports.addMessage = functions.https.onRequest((req, res) => {
    const original = req.query.text;

    return admin.database().ref('/messages').update({
        testKey: original
    }).then((snapshot) => {
        return res.redirect(303, snapshot.ref.toString());
    });
})