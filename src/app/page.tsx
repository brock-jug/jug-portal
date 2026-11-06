import Link from "next/link";

export default function Home() {
  return (
    <main className="p-8 space-y-4">
      <h1 className="text-2xl font-semibold">JUG Portal</h1>
      <ul className="list-disc pl-6">
        <li><Link className="underline" href="/staff">Staff portal</Link></li>
        <li><Link className="underline" href="/order">Wholesale ordering</Link></li>
      </ul>
    </main>
  );
}
