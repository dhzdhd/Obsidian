<script lang="ts">
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
				Lorem ipsum dolor sit amet, consectetur adipisicing elit. Dicta distinctio natus assumenda
				error! Voluptate, labore reprehenderit similique repellat quam optio neque provident quod
				nesciunt ab deleniti ad beatae corrupti quae! Lorem ipsum dolor sit amet consectetur
				adipisicing elit. Rerum ipsum, nesciunt, labore sapiente numquam minus ad illo ea id in
				perspiciatis mollitia corporis nam quisquam impedit quasi. Aspernatur, dolore magnam.
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
					<h2 class="mb-2 text-lg font-bold text-green-500 title-font">Moderation</h2>
					<p class="text-base leading-relaxed text-gray-400">
						Lorem ipsum dolor sit, amet consectetur adipisicing elit. Quis culpa nesciunt iusto
						facere quam laboriosam deserunt omnis sunt reiciendis distinctio quia, dolorum molestiae
						placeat velit, recusandae sint, necessitatibus odio accusamus!
					</p>
				</div>
			</div>
			<div
				class="flex flex-col items-center pb-10 mx-auto mb-10 border-b border-gray-800 lg:w-3/5 sm:flex-row"
			>
				<div class="flex-grow mt-6 text-center sm:mt-0">
					<h2 class="mb-2 text-lg font-bold text-green-500 title-font">Music</h2>
					<p class="text-base leading-relaxed text-gray-400">
						Lorem ipsum dolor sit amet consectetur adipisicing elit. Modi rerum voluptatem illum
						itaque obcaecati facilis neque molestiae quod suscipit voluptatibus. Debitis, totam?
						Odit quod, nihil laudantium maiores recusandae sit perferendis?
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
						Lorem ipsum dolor sit, amet consectetur adipisicing elit. Excepturi commodi accusamus
						blanditiis officia molestias, ex in incidunt quos qui explicabo, numquam voluptas
						doloremque rerum. Dolorum aliquid dolores quidem nemo temporibus!
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
					Lorem ipsum dolor sit amet consectetur adipisicing elit. Molestias dolores eligendi
					perferendis qui dolore eius autem laboriosam, adipisci hic similique commodi ut
					aspernatur? Corporis earum nobis nam, laboriosam temporibus velit!
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
			<div class="w-full p-2 lg:w-1/3 md:w-1/2">
				<div class="flex items-center h-full p-4 border border-gray-600 rounded-lg">
					<div class="flex-grow">
						<a class="font-medium text-green-400 title-font" href="https://github.com/dhzdhd"
							>dhzdhd</a
						>
						<p class="text-gray-400">Owner</p>
					</div>
				</div>
			</div>
			<div class="w-full p-2 lg:w-1/3 md:w-1/2">
				<div class="flex items-center h-full p-4 border border-gray-600 rounded-lg">
					<div class="flex-grow">
						<a class="font-medium text-green-400 title-font" href="https://github.com/Arnav-2004"
							>Arnav</a
						>
						<p class="text-gray-400">Contributor</p>
					</div>
				</div>
			</div>
			<div class="w-full p-2 lg:w-1/3 md:w-1/2">
				<div class="flex items-center h-full p-4 border border-gray-600 rounded-lg">
					<div class="flex-grow">
						<a class="font-medium text-green-400 title-font" href="https://github.com/ItzLukaDev"
							>Luka</a
						>
						<p class="text-gray-400">Contributor</p>
					</div>
				</div>
			</div>
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
					Lorem ipsum dolor sit amet, consectetur adipisicing elit. Beatae magnam praesentium
					molestias, magni ratione eveniet hic tenetur dolorem voluptatibus illum assumenda eum
					omnis ut ad nemo esse, expedita nobis necessitatibus.
				</p>
				<div class="flex justify-center">
					<button
						class="inline-flex px-6 py-2 text-lg text-white bg-green-500 border-0 rounded focus:outline-none hover:bg-green-600"
						>Support Server</button
					>
					<a
						href="pages/docs.html"
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
		© 2022
		<a class="font-bold text-green-400" href="https://github.com/dhzdhd/Obsidian/">Obsidian</a>
	</div>
</footer>
