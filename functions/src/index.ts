import * as functions from "firebase-functions/v2";
import axios from "axios";
import * as dotenv from "dotenv";

dotenv.config();


export const fetchImages = functions.https.onCall( async (request) => {
  if (!request.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "Please Login"
    );
  }
  const search = request.data.search || "";
  const page = request.data.page || 1;

  const API_KEY = process.env.PEXELS_KEY;
  if (!API_KEY) {
    throw new functions.https.HttpsError(
      "internal",
      "API Key missing!"
    );
  }

  try {
    const response = await axios.get(
      "https://api.pexels.com/v1/search",
      {
        headers: {Authorization: API_KEY},
        params: {
          query: search,
          per_page: 50,
          page: page,
        },
      }
    );

    const photos = response.data.photos.map((e: any) => ({
      describtion: e.alt || "",
      largeImg: e.src.large,
      mediumImg: e.src.medium,
      originalImg: e.src.original,
      photographer: e.photographer || "",
      photographerUrl: e.photographer_url || "",
      smallImg: e.src.small,
      url: e.url || "",
      id: e.id || 0,
      page: page,
      title: search,
      isBookmarked: false,
    }));

    return {pages: page, title: search, photos};
  } catch (e: any) {
    const status = e?.response?.status;
    const message = e?.response?.data?.error || "Pexels API error!";

    if (status === 401) {
      throw new functions.https.HttpsError("unauthenticated", message);
    } else if (status === 429) {
      throw new functions.https.HttpsError("resource-exhausted", message);
    } else {
      throw new functions.https.HttpsError("internal", message);
    }
  }
});
