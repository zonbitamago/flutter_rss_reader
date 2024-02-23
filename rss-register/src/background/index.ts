import Parser from "rss-parser";
import { initializeApp } from "firebase/app";

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID,
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
      console.log(app);
      console.log(import.meta.env);
      console.log(firebaseConfig);

      //   feed.items.forEach((item) => {
      //     console.log(item.title + ":" + item.link);
      //   });
    })();
  });
}
