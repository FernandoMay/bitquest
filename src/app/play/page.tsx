"use client";

import { useEffect, useRef } from "react";
import { useRouter } from "next/navigation";

export default function PlayPage() {
  const router = useRouter();
  const iframeRef = useRef<HTMLIFrameElement>(null);

  useEffect(() => {
    // Opcional: Redirigir si no hay soporte para iframe
    const checkIframeSupport = () => {
      if (typeof window !== 'undefined') {
        const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
          navigator.userAgent
        );
        
        if (isMobile) {
          // En móviles, redirigir directamente a la app
          router.push("/download");
          return false;
        }
      }
      return true;
    };

    if (!checkIframeSupport()) {
      return;
    }

    // Comunicación con el iframe para tracking
    const handleMessage = (event: MessageEvent) => {
      // Procesar mensajes desde Flutter app
      if (event.data?.type === 'flutter_app') {
        switch (event.data?.action) {
          case 'mission_completed':
            // Enviar analytics
            console.log('Mission completed:', event.data.missionId);
            break;
          case 'level_up':
            console.log('Level up:', event.data.newLevel);
            break;
          case 'share_progress':
            // Compartir progreso con Next.js app
            console.log('Share progress:', event.data.progress);
            break;
        }
      }
    };

    window.addEventListener('message', handleMessage);
    return () => window.removeEventListener('message', handleMessage);
  }, [router]);

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="border-b border-border bg-card/50 backdrop-blur-sm sticky top-0 z-50">
        <div className="container mx-auto px-4 py-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-primary to-purple-500 flex items-center justify-center">
                <span className="text-white font-bold text-sm">BQ</span>
              </div>
              <h1 className="text-lg font-bold">BITQUEST Play</h1>
            </div>
            
            <div className="flex items-center gap-2">
              <a 
                href="/download" 
                className="text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                Descargar App
              </a>
              <a 
                href="/" 
                className="text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                Inicio
              </a>
            </div>
          </div>
        </div>
      </div>

      {/* Flutter App Container */}
      <div className="relative w-full h-[calc(100vh-60px)]">
        <iframe
          ref={iframeRef}
          src="/flutter/index.html"
          className="w-full h-full border-0"
          title="BITQUEST Game"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowFullScreen
          loading="eager"
        />
        
        {/* Loading Overlay */}
        <div className="absolute inset-0 bg-background flex items-center justify-center pointer-events-none" id="loading-overlay">
          <div className="text-center space-y-4">
            <div className="w-16 h-16 rounded-full bg-gradient-to-br from-primary to-purple-500 animate-pulse" />
            <div className="space-y-2">
              <h2 className="text-xl font-bold">Cargando BITQUEST...</h2>
              <p className="text-muted-foreground">Preparando tu aventura Bitcoin</p>
            </div>
          </div>
        </div>
      </div>

      <script dangerouslySetInnerHTML={{
        __html: `
          // Ocultar loading cuando la app Flutter esté lista
          window.addEventListener('message', function(event) {
            if (event.data?.type === 'flutter_app' && event.data?.action === 'app_loaded') {
              const loadingOverlay = document.getElementById('loading-overlay');
              if (loadingOverlay) {
                loadingOverlay.style.display = 'none';
              }
            }
          });
        `
      }} />
    </div>
  );
}
