import Link from "next/link";

const Footer = () => {
  return (
    <footer className="py-6">
      <div className="container mx-auto flex flex-col items-center space-y-10">
        <div className="flex flex-row justify-center items-center space-y-0 space-x-10">
          <Link
            href="/privacy-policy"
            className="text-center underline text-base"
          >
            Privacy Policy
          </Link>
          <Link
            href="/terms-of-use"
            className="text-center underline text-base"
          >
            Terms of Use
          </Link>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
