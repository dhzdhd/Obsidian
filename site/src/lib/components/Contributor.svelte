<script lang="ts">
  import { onMount } from 'svelte';

  interface ContributorJson {
    name: string;
    avatar: string;
    contributions: number;
    url: string;
  }

  let contributorList: ContributorJson[] = [];

  onMount(async () => {
    const res = await fetch('https://api.github.com/repos/dhzdhd/Obsidian/contributors');
    const data = await res.json();
    console.log(data);

    contributorList = data.map((val: any): ContributorJson => {
      return {
        name: val['login'],
        avatar: val['avatar_url'],
        contributions: val['contributions'],
        url: val['html_url']
      };
    });
  });

  console.log(contributorList);
</script>

{#each contributorList as item}
  <div class="w-full p-2 md:w-1/2 lg:w-1/3">
    <div class="flex h-full items-center rounded-lg border border-gray-600 p-4">
      <div class="flex-grow">
        <a class="title-font font-medium text-green-400" href={item.url}>{item.name}</a>
        <p class="text-gray-400">Contributions: {item.contributions}</p>
      </div>
    </div>
  </div>
{/each}
