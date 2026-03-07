import type { Metadata, Viewport } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";
import { Toaster } from "@/components/ui/toaster";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "BITQUEST | Aprende Bitcoin Jugando",
  description: "Plataforma educativa gamificada donde aprendes Bitcoin mediante misiones, simulaciones y retos interactivos. Educación financiera para México.",
  keywords: ["Bitcoin", "Educación financiera", "México", "Blockchain", "Lightning Network", "Gamificación", "Aprender Bitcoin", "Criptomonedas"],
  authors: [{ name: "BITQUEST Team" }],
  icons: {
    icon: "/favicon.ico",
  },
  openGraph: {
    title: "BITQUEST | Aprende Bitcoin Jugando",
    description: "La forma más divertida de aprender Bitcoin. Misiones, minijuegos y recompensas.",
    url: "https://bitquest.mx",
    siteName: "BITQUEST",
    type: "website",
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
        alt: "BITQUEST - Aprende Bitcoin Jugando",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "BITQUEST | Aprende Bitcoin Jugando",
    description: "La forma más divertida de aprender Bitcoin. Misiones, minijuegos y recompensas.",
    images: ["/og-image.png"],
  },
  manifest: "/manifest.json",
};

export const viewport: Viewport = {
  themeColor: "#F7931A",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es" suppressHydrationWarning className="dark">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased bg-background text-foreground min-h-screen flex flex-col`}
      >
        {children}
        <Toaster />
      </body>
    </html>
  );
}
