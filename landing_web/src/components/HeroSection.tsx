import Image from "next/image";
import {
  ANDROID_APP_STORE_URL,
  IOS_APP_STORE_URL,
  SITE_DESCRIPTION,
} from "@/constants/site";

const HeroSection = () => {
  return (
    <section className="hero flex flex-col items-center py-8 px-4 md:px-8 space-y-10">
      <h1 className="text-black font-bold text-[44px] md:text-[48px] text-center max-w-3xl">
        {SITE_DESCRIPTION}
      </h1>
      <div className="flex space-x-4">
        <a
          href={IOS_APP_STORE_URL}
          className="hover:opacity-80 transition"
          target="_blank"
          rel="noopener noreferrer"
        >
          <Image
            src="/assets/store_buttons/app-store-badge.svg"
            alt="Download WeeksAlive on the App Store"
            width={200}
            height={60}
          />
        </a>
        <a
          href={ANDROID_APP_STORE_URL}
          className="hover:opacity-80 transition"
          target="_blank"
          rel="noopener noreferrer"
        >
          <Image
            src="/assets/store_buttons/google-play-badge.svg"
            alt="Get WeeksAlive on Google Play"
            width={220}
            height={60}
          />
        </a>
      </div>

      <div className="mt-8 flex flex-wrap justify-center gap-8">
        <Image
          src="/assets/illustrations/frame_0_1x.webp"
          alt="Feel your time. Don't just spend it."
          width={250}
          height={250}
          className="shadow-[0_20px_25px_-5px_rgba(0,0,0,0.1),0_10px_10px_-5px_rgba(0,0,0,0.04)] rounded-2xl"
        />
        <Image
          src="/assets/illustrations/frame_1_1x.webp"
          alt="Some days weigh more than others."
          width={250}
          height={250}
          className="shadow-[0_20px_25px_-5px_rgba(0,0,0,0.1),0_10px_10px_-5px_rgba(0,0,0,0.04)] rounded-2xl"
        />
        <Image
          src="/assets/illustrations/frame_2_1x.webp"
          alt="Reflect in 60 seconds a day."
          width={250}
          height={250}
          className="shadow-[0_20px_25px_-5px_rgba(0,0,0,0.1),0_10px_10px_-5px_rgba(0,0,0,0.04)] rounded-2xl"
        />
        <Image
          src="/assets/illustrations/frame_3_1x.webp"
          alt="Your life in weeks."
          width={250}
          height={250}
          className="shadow-[0_20px_25px_-5px_rgba(0,0,0,0.1),0_10px_10px_-5px_rgba(0,0,0,0.04)] rounded-2xl"
        />
        <Image
          src="/assets/illustrations/frame_4_1x.webp"
          alt="Wallpapers and widgets"
          width={250}
          height={250}
          className="shadow-[0_20px_25px_-5px_rgba(0,0,0,0.1),0_10px_10px_-5px_rgba(0,0,0,0.04)] rounded-2xl"
        />
        <Image
          src="/assets/illustrations/frame_5_1x.webp"
          alt="Live each week with intention"
          width={250}
          height={250}
          className="shadow-[0_20px_25px_-5px_rgba(0,0,0,0.1),0_10px_10px_-5px_rgba(0,0,0,0.04)] rounded-2xl"
        />
      </div>
    </section>
  );
};

export default HeroSection;
