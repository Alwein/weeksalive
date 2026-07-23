import { SITE_NAME } from "@/constants/site";
import Image from "next/image";
import Link from "next/link";

const Header = () => {
  return (
    <header className="sticky top-0 z-50 bg-white flex justify-between items-center py-5">
      <div className="logo flex-shrink-0">
        <Link href="/">
          <Image
            src="/assets/logo.svg"
            alt={`${SITE_NAME} app logo`}
            width={150}
            height={50}
          />
        </Link>
      </div>
    </header>
  );
};

export default Header;
