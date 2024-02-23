import Parser from "rss-parser";
import { initializeApp } from "firebase/app";
import {
  addDoc,
  collection,
  getDocs,
  getFirestore,
  query,
  updateDoc,
  where,
} from "firebase/firestore";

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
      const db = getFirestore(app);

      try {
        // firestoreにupsertする
        const rssCollection = collection(db, "rss");
        const rssQuery = query(rssCollection, where("url", "==", url));
        const rssSnapshot = await getDocs(rssQuery);

        if (rssSnapshot.empty) {
          // Document doesn't exist, create a new one
          const docRef = await addDoc(rssCollection, {
            url: url,
            title: feed.title,
          });
          console.log("Document written with ID: ", docRef.id);
        } else {
          // Document exists, update it
          const docRef = rssSnapshot.docs[0].ref;
          await updateDoc(docRef, {
            url: url,
            title: feed.title,
          });
          console.log("Document updated with ID: ", docRef.id);
        }
      } catch (e) {
        console.error("Error adding document: ", e);
      }
    })();
  });
}
