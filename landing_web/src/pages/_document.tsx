import { SITE_DESCRIPTION, SITE_NAME, SITE_URL } from "@/constants/site";
import { Head, Html, Main, NextScript } from "next/document";

export default function Document() {
  return (
    <Html lang="en">
      <Head>
        <link rel="icon" href="/favicon.ico" />
        <meta charSet="utf-8" />
        <meta name="description" content={SITE_DESCRIPTION} />
        <meta property="og:title" content={SITE_NAME} />
        <meta property="og:description" content={SITE_DESCRIPTION} />
        <meta property="og:type" content="website" />
        <meta property="og:url" content={SITE_URL} />
      </Head>
      <body className="max-w-7xl mx-auto px-8 py-5">
        <Main />
        <NextScript />
      </body>
    </Html>
  );
}
