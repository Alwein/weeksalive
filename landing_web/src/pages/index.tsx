import Footer from "../components/Footer";
import Header from "../components/Header";
import HeroSection from "../components/HeroSection";
import { SITE_DESCRIPTION, SITE_NAME } from "@/constants/site";
import Head from "next/head";

export default function Home() {
  return (
    <>
      <Head>
        <title>{`${SITE_NAME} — Not to track time. To help you feel it.`}</title>
        <meta name="description" content={SITE_DESCRIPTION} />
      </Head>
      <Header />
      <HeroSection />
      <Footer />
    </>
  );
}
