import { SITE_NAME } from "@/constants/site";
import "github-markdown-css/github-markdown-light.css";
import { useEffect, useState } from "react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import Footer from "../components/Footer";
import Header from "../components/Header";
import Head from "next/head";

const TermsOfUsePage = () => {
  const [content, setContent] = useState("");

  useEffect(() => {
    fetch("/terms-of-use.md")
      .then((response) => response.text())
      .then((text) => setContent(text))
      .catch((error) => console.error(error));
  }, []);

  return (
    <>
      <Head>
        <title>{`Terms of Use — ${SITE_NAME}`}</title>
      </Head>
      <Header />
      <div className="markdown-body">
        <ReactMarkdown remarkPlugins={[remarkGfm]}>{content}</ReactMarkdown>
      </div>
      <Footer />
    </>
  );
};

export default TermsOfUsePage;
