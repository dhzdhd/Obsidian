<script lang="ts">
  import Contributor from '$lib/components/Contributor.svelte';

  import Header from '$lib/components/Header.svelte';
</script>

<svelte:head>
  <title>Obsidian</title>
</svelte:head>

<Header />
<section class="bg-gradient-to-br from-gray-900 to-gray-800 body-font">
  <div class="flex flex-col items-center justify-center px-5 py-24">
    <img
      class="object-cover object-center mb-10 rounded-full"
      alt="hero"
      src="favicon.png"
      width="200px"
      height="200px"
    />
    <div class="w-full text-center lg:w-2/3">
      <h1 class="mb-4 text-3xl font-bold text-green-500 title-font sm:text-4xl">
        Obsidian. The multipurpose Discord bot.
      </h1>
      <p class="mb-8 leading-relaxed text-gray-400">
        Obsidian is a multipurpose, self hosted, slash command only discord bot written in Dart lang
        with the nyxx library.
      </p>
      <div class="flex justify-center">
        <a
          class="inline-flex px-6 py-2 text-lg text-white bg-green-500 border-0 rounded focus:outline-none hover:bg-green-600"
          href="#features"
        >
          See Features
        </a>
      </div>
    </div>
  </div>
</section>

<div id="features">
  <section class="text-center bg-gray-900 body-font">
    <div class="px-5 py-24 mx-auto ">
      <div
        class="flex flex-col items-center pb-10 mx-auto mb-10 border-b border-gray-800 lg:w-3/5 sm:flex-row"
      >
        <div class="flex-grow mt-6 text-center sm:mt-0">
          <h1 class="mb-16 text-3xl font-bold text-green-500 title-font sm:text-4xl">Features</h1>
          <h2 class="mb-2 text-lg font-bold text-green-500 title-font">Fun and Moderation</h2>
          <p class="text-base leading-relaxed text-gray-400">
            The bot comes with loads of fun, moderation and utility slash commands.
          </p>
        </div>
      </div>
      <div
        class="flex flex-col items-center pb-10 mx-auto mb-10 border-b border-gray-800 lg:w-3/5 sm:flex-row"
      >
        <div class="flex-grow mt-6 text-center sm:mt-0">
          <h2 class="mb-2 text-lg font-bold text-green-500 title-font">Music</h2>
          <p class="text-base leading-relaxed text-gray-400">
            Music in this bot is facilitated by the lavalink library. Listen to music from Youtube
            and SoundCloud and other sources with near 0 lag
          </p>
        </div>
        <div
          class="inline-flex items-center justify-center flex-shrink-0 text-green-400 bg-gray-800 rounded-full"
        />
      </div>
      <div class="flex flex-col items-center mx-auto lg:w-3/5 sm:flex-row">
        <div
          class="inline-flex items-center justify-center flex-shrink-0 text-green-400 bg-gray-800 rounded-full"
        />
        <div class="flex-grow mt-6 text-center sm:mt-0">
          <h2 class="mb-2 text-lg font-bold text-green-500 title-font">Open Source</h2>
          <p class="text-base leading-relaxed text-gray-400">
            This bot is fully open source and self hosted. Knowing Dart lang and a bit of the nyxx
            library, you can easily tweak the code to suit your needs.
          </p>
        </div>
      </div>
      <a
        class="inline-flex justify-center px-6 py-2 mt-16 text-lg text-white bg-green-500 border-0 rounded-full focus:outline-none hover:bg-green-600"
        href="#contributing"
      >
        Contribute
      </a>
    </div>
  </section>
</div>
<div id="contributing">
  <section class="bg-gradient-to-br from-gray-900 to-gray-800 body-font">
    <div class="flex flex-col items-center justify-center px-5 py-24 mx-auto ">
      <div class="w-full text-center lg:w-2/3">
        <h1 class="mb-4 text-3xl font-bold text-green-500 title-font sm:text-4xl">
          Conributing To Obsidian
        </h1>
        <p class="mb-8 leading-relaxed text-gray-400">
          Contributions to Obsidian are welcome! Prior knowledge of Dart lang and the nyxx wrapper
          library is a must for bot development. To help improve the site, knowledge of SvelteKit
          and WindiCSS is required. You can also help improve the documentation and report general
          grammar and spelling errors.
        </p>
        <div class="flex justify-center">
          <a
            class="inline-flex px-6 py-2 text-lg text-white bg-green-500 border-0 rounded focus:outline-none hover:bg-green-600"
            href="https://github.com/dhzdhd/Obsidian#contributing">Contributing Guidelines</a
          >
          <a
            class="inline-flex px-6 py-2 ml-4 text-lg text-white bg-green-500 border-0 rounded focus:outline-none hover:bg-green-600"
            href="https://github.com/dhzdhd/Obsidian">GitHub</a
          >
        </div>
      </div>
    </div>
  </section>
</div>
<section class="text-gray-400 bg-gradient-to-br from-gray-900 to-gray-800 body-font">
  <div class="px-5 py-24 mx-auto">
    <div class="flex flex-col w-full mb-20 text-center">
      <h1 class="mb-4 text-3xl font-bold text-green-500 sm:text-4xl title-font">Contributors</h1>
    </div>
    <div class="flex flex-wrap -m-2">
      <Contributor />
    </div>
  </div>
</section>
<div id="support">
  <section class="text-gray-400 bg-gray-900 body-font">
    <div class="flex flex-col items-center justify-center px-5 py-24 mx-auto ">
      <div class="w-full text-center lg:w-2/3">
        <h1 class="mb-4 text-3xl font-bold text-green-500 title-font sm:text-4xl">
          Need Help? We got you.
        </h1>
        <p class="mb-8 leading-relaxed text-gray-400">
          Join our support server for help related to commands or general questions about the bot.
          Also check the documentation for detailed information on each command which can solve your
          doubts and save time.
        </p>
        <div class="flex justify-center">
          <a
            href="https://discord.gg/6zVggku2qX"
            class="inline-flex px-6 py-2 text-lg text-white bg-green-500 border-0 rounded focus:outline-none hover:bg-green-600"
            >Support Server</a
          >
          <a
            href="/docs"
            class="inline-flex px-6 py-2 ml-4 text-lg text-white bg-green-500 border-0 rounded focus:outline-none hover:bg-green-600"
            >Obsidian Docs</a
          >
        </div>
      </div>
    </div>
  </section>
</div>
<footer class="text-center text-white bg-gray-800">
  <div class="p-4 text-center">
    2022
    <a class="font-bold text-green-400" href="https://github.com/dhzdhd/Obsidian/">Obsidian</a>
  </div>
</footer>
