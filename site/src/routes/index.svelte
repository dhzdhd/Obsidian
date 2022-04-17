<script lang="ts">
  import Contributor from '$lib/components/Contributor.svelte';

  import Header from '$lib/components/Header.svelte';
</script>

<svelte:head>
  <title>Obsidian</title>
</svelte:head>

<Header />
<section class="body-font bg-gradient-to-br from-gray-900 to-gray-800">
  <div class="flex flex-col items-center justify-center px-5 py-24">
    <img
      class="mb-10 rounded-full object-cover object-center"
      alt="hero"
      src="favicon.png"
      width="200px"
      height="200px"
    />
    <div class="w-full text-center lg:w-2/3">
      <h1 class="title-font mb-4 text-3xl font-bold text-green-500 sm:text-4xl">
        Obsidian. The multipurpose Discord bot.
      </h1>
      <p class="mb-8 leading-relaxed text-gray-400">
        Obsidian is a multipurpose, self hosted, slash command only discord bot written in Dart lang
        with the nyxx library.
      </p>
      <div class="flex justify-center">
        <a
          class="inline-flex rounded border-0 bg-green-500 px-6 py-2 text-lg text-white hover:bg-green-600 focus:outline-none"
          href="#features"
        >
          See Features
        </a>
      </div>
    </div>
  </div>
</section>

<div id="features">
  <section class="body-font bg-gray-900 text-center">
    <div class="mx-auto px-5 py-24 ">
      <div
        class="mx-auto mb-10 flex flex-col items-center border-b border-gray-800 pb-10 sm:flex-row lg:w-3/5"
      >
        <div class="mt-6 flex-grow text-center sm:mt-0">
          <h1 class="title-font mb-16 text-3xl font-bold text-green-500 sm:text-4xl">Features</h1>
          <h2 class="title-font mb-2 text-lg font-bold text-green-500">Fun and Moderation</h2>
          <p class="text-base leading-relaxed text-gray-400">
            The bot comes with loads of fun, moderation and utility slash commands.
          </p>
        </div>
      </div>
      <div
        class="mx-auto mb-10 flex flex-col items-center border-b border-gray-800 pb-10 sm:flex-row lg:w-3/5"
      >
        <div class="mt-6 flex-grow text-center sm:mt-0">
          <h2 class="title-font mb-2 text-lg font-bold text-green-500">Music</h2>
          <p class="text-base leading-relaxed text-gray-400">
            Music in this bot is facilitated by the lavalink library. Listen to music from Youtube
            and SoundCloud and other sources with near 0 lag
          </p>
        </div>
        <div
          class="inline-flex flex-shrink-0 items-center justify-center rounded-full bg-gray-800 text-green-400"
        />
      </div>
      <div class="mx-auto flex flex-col items-center sm:flex-row lg:w-3/5">
        <div
          class="inline-flex flex-shrink-0 items-center justify-center rounded-full bg-gray-800 text-green-400"
        />
        <div class="mt-6 flex-grow text-center sm:mt-0">
          <h2 class="title-font mb-2 text-lg font-bold text-green-500">Open Source</h2>
          <p class="text-base leading-relaxed text-gray-400">
            This bot is fully open source and self hosted. Knowing Dart lang and a bit of the nyxx
            library, you can easily tweak the code to suit your needs.
          </p>
        </div>
      </div>
      <a
        class="mt-16 inline-flex justify-center rounded-full border-0 bg-green-500 px-6 py-2 text-lg text-white hover:bg-green-600 focus:outline-none"
        href="#contributing"
      >
        Contribute
      </a>
    </div>
  </section>
</div>
<div id="contributing">
  <section class="body-font bg-gradient-to-br from-gray-900 to-gray-800">
    <div class="mx-auto flex flex-col items-center justify-center px-5 py-24 ">
      <div class="w-full text-center lg:w-2/3">
        <h1 class="title-font mb-4 text-3xl font-bold text-green-500 sm:text-4xl">
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
            class="inline-flex rounded border-0 bg-green-500 px-6 py-2 text-lg text-white hover:bg-green-600 focus:outline-none"
            href="https://github.com/dhzdhd/Obsidian#contributing">Contributing Guidelines</a
          >
          <a
            class="ml-4 inline-flex rounded border-0 bg-green-500 px-6 py-2 text-lg text-white hover:bg-green-600 focus:outline-none"
            href="https://github.com/dhzdhd/Obsidian">GitHub</a
          >
        </div>
      </div>
    </div>
  </section>
</div>
<section class="body-font bg-gradient-to-br from-gray-900 to-gray-800 text-gray-400">
  <div class="mx-auto px-5 py-24">
    <div class="mb-20 flex w-full flex-col text-center">
      <h1 class="title-font mb-4 text-3xl font-bold text-green-500 sm:text-4xl">Contributors</h1>
    </div>
    <div class="-m-2 flex flex-wrap">
      <Contributor />
    </div>
  </div>
</section>
<div id="support">
  <section class="body-font bg-gray-900 text-gray-400">
    <div class="mx-auto flex flex-col items-center justify-center px-5 py-24 ">
      <div class="w-full text-center lg:w-2/3">
        <h1 class="title-font mb-4 text-3xl font-bold text-green-500 sm:text-4xl">
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
            class="inline-flex rounded border-0 bg-green-500 px-6 py-2 text-lg text-white hover:bg-green-600 focus:outline-none"
            >Support Server</a
          >
          <a
            href="/docs"
            class="ml-4 inline-flex rounded border-0 bg-green-500 px-6 py-2 text-lg text-white hover:bg-green-600 focus:outline-none"
            >Obsidian Docs</a
          >
        </div>
      </div>
    </div>
  </section>
</div>
<footer class="bg-gray-800 text-center text-white">
  <div class="p-4 text-center">
    2022
    <a class="font-bold text-green-400" href="https://github.com/dhzdhd/Obsidian/">Obsidian</a>
  </div>
</footer>
