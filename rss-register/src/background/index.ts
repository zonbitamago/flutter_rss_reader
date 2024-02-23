import Parser from "rss-parser";

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
      //   feed.items.forEach((item) => {
      //     console.log(item.title + ":" + item.link);
      //   });
    })();
  });
}
