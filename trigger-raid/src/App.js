import React, { Component } from "react";
import logo from "./logo.svg";
import "./App.css";
import firebase from "@firebase/app";
import "@firebase/firestore";

class App extends Component {
  componentDidMount() {
    // ADD CONFIGURATION HERE
    var config = {};
    firebase.initializeApp(config);
  }

  render() {
    return (
      <div className="App">
        <button onClick={this.updateFirestoreThing}>UPDATE</button>
      </div>
    );
  }

  updateFirestoreThing() {
    var db = firebase.firestore();
    var idRef = db.collection("test");
    var testRef = db.collection("test").doc("testID");

    testRef.get().then(doc => {
      if (doc.exists) {
        var previousValue = doc.data().testField;
        testRef.set({
          testField: !previousValue
        });
        console.log(`Setting testField to: ${!previousValue}`);
      } else {
        console.error("ugh");
      }
    });
  }
}

export default App;
