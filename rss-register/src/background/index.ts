import Parser from "rss-parser";
import { initializeApp } from "firebase/app";
import "dotenv/config";

const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.FIREBASE_APP_ID,
  measurementId: process.env.FIREBASE_MEASUREMENT_ID,
};

{
  chrome.action.onClicked.addListener(async (tab) => {
    const url = tab.url;
    console.log(url);

    if (url === undefined) {
      console.log("url is undefined");
      return;
    }

    await (async () => {
      const parser = new Parser();
      const feed = await parser.parseURL(url);
      console.log(feed.title);

      // Initialize Firebase
      const app = initializeApp(firebaseConfig);

      //   feed.items.forEach((item) => {
      //     console.log(item.title + ":" + item.link);
      //   });
    })();
  });
}
