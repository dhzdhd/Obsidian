<script lang="ts" context="module">
  interface ContributorJson {
    name: string;
    avatar: string;
    contributions: number;
    url: string;
  }

  export const load = async ({  }) => {
    const res = await fetch('https://api.github.com/repos/dhzdhd/Obsidian/contributors');
    const json = await res.json();
    const contributorList = json.map((val: any): ContributorJson => {
        return {
          name: val['login'],
          avatar: val['avatar_url'],
          contributions: val['contributions'],
          url: val['url']
        };
      });
    return {
      props: { contributorList },
    };
  };
</script>

<script lang="ts">
    export let contributorList: ContributorJson[] = [];
    console.log(contributorList);
</script>

{#each contributorList as item}
<div class="w-full p-2 lg:w-1/3 md:w-1/2">
    <div class="flex items-center h-full p-4 border border-gray-600 rounded-lg">
      <div class="flex-grow">
        <a class="font-medium text-green-400 title-font" href="https://github.com/ItzLukaDev">{ item.name }</a>
        <p class="text-gray-400">Contributor</p>
        { contributorList[1] }
      </div>
    </div>
  </div>
{/each}
