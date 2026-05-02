-- Changelog text displayed by /mj version, keyed by locale.
-- Falls back to enUS if the player's locale is not listed.
local _cl = {}

_cl["enUS"] = [=[
|cffffd700v2.0.0|r
  |cffcccccc• Removed TomTom dependency — waypoints fully built-in|r
  |cffcccccc• Waypoints persist across /reload (SavedVariables)|r
  |cffcccccc• Minimap and world map icons use addon texture|r
  |cffcccccc• Tooltip waypoint button now has a dark background|r
  |cffcccccc• /mj clear immediately updates overlay button text|r
  |cffcccccc• Fixed overlay nil error on first clear|r
  |cffcccccc• Remove Current always visible in right-click menu|r
  |cffcccccc• Fixed arrow tracking wrong waypoint after removal|r
  |cffcccccc• Right-click lure selector shows all active waypoints|r
  |cffcccccc• Selected lure persists across /reload|r
  |cffcccccc• Shows "Go to <Zone>" when selected lure is on a different map|r
  |cffcccccc• Lure menu labels show creature and zone name|r

|cffffd700v1.0.0|r
  |cffcccccc• Quest status: /mj status, /mj way, /mj all, /mj clear|r
  |cffcccccc• TomTom integration for minimap and world map|r
  |cffcccccc• HUD directional arrow (drag, lock, size)|r
  |cffcccccc• Lure tooltip overlay: Available / Skinned today|r
  |cffcccccc• Full localisation: 9 locales|r
  |cffcccccc• Addon icon and title added to TOC|r
  |cffcccccc• Fixed locale encoding (UTF-8 literals)|r

|cffffd700v0.2.0|r
  |cffcccccc• Fixed nil error on tooltip data.id (legacy API)|r
  |cffcccccc• Replaced octal escape sequences in locale files|r

|cffffd700v0.1.0|r
  |cffcccccc• Lure tooltip: Available (green) / Skinned today (red)|r
  |cffcccccc• Clickable waypoint button on lure tooltip hover|r
  |cffcccccc• TomTom changed from RequiredDeps to OptionalDeps|r
  |cffcccccc• Added locale keys across all 9 locales|r]=]

_cl["deDE"] = [=[
|cffffd700v2.0.0|r
  |cffcccccc• TomTom-Abhängigkeit entfernt – Wegpunkte vollständig eingebaut|r
  |cffcccccc• Wegpunkte bleiben nach /reload erhalten (SavedVariables)|r
  |cffcccccc• Minimap- und Weltkarten-Symbole verwenden Addon-Textur|r
  |cffcccccc• Tooltip-Wegpunkt-Schaltfläche hat jetzt einen dunklen Hintergrund|r
  |cffcccccc• /mj clear aktualisiert den Overlay-Text sofort|r
  |cffcccccc• Nil-Fehler beim ersten Löschen behoben|r
  |cffcccccc• „Aktuellen entfernen“ im Rechtsklick-Menü immer sichtbar|r
  |cffcccccc• Pfeil verfolgte nach dem Entfernen falsche Wegpunkte – behoben|r
  |cffcccccc• Köder-Auswahl zeigt alle aktiven Wegpunkte|r
  |cffcccccc• Ausgewählter Köder bleibt nach /reload erhalten|r
  |cffcccccc• „Gehe zu <Zone>“ wenn Köder auf einer anderen Karte ist|r
  |cffcccccc• Köder-Menü zeigt Kreatur und Zonenname|r

|cffffd700v1.0.0|r
  |cffcccccc• Queststatus: /mj status, /mj way, /mj all, /mj clear|r
  |cffcccccc• TomTom-Integration für Minimap und Weltkarte|r
  |cffcccccc• HUD-Richtungspfeil (ziehen, sperren, Größe)|r
  |cffcccccc• Köder-Tooltip-Overlay: Verfügbar / Heute gehäutet|r
  |cffcccccc• Vollständige Lokalisierung: 9 Sprachen|r
  |cffcccccc• Addon-Symbol und Titel zur TOC hinzugefügt|r
  |cffcccccc• Lokalisierungskodierung korrigiert (UTF-8)|r

|cffffd700v0.2.0|r
  |cffcccccc• Nil-Fehler bei tooltip data.id behoben (Legacy-API)|r
  |cffcccccc• Oktale Escape-Sequenzen in Lokalisierungsdateien ersetzt|r

|cffffd700v0.1.0|r
  |cffcccccc• Köder-Tooltip: Verfügbar (grün) / Heute gehäutet (rot)|r
  |cffcccccc• Anklickbare Wegpunkt-Schaltfläche beim Köder-Tooltip|r
  |cffcccccc• TomTom von RequiredDeps auf OptionalDeps geändert|r
  |cffcccccc• Lokalisierungsschlüssel für alle 9 Sprachen hinzugefügt|r]=]

_cl["frFR"] = [=[
|cffffd700v2.0.0|r
  |cffcccccc• Dépendance TomTom supprimée – points de passage entièrement intégrés|r
  |cffcccccc• Les points de passage persistent après /reload (SavedVariables)|r
  |cffcccccc• Icônes de la minicarte et de la carte du monde utilisent la texture de l'addon|r
  |cffcccccc• Le bouton de point de passage dans l'info-bulle a maintenant un fond sombre|r
  |cffcccccc• /mj clear met à jour immédiatement le texte du bouton|r
  |cffcccccc• Correction de l'erreur nil lors du premier effacement|r
  |cffcccccc• "Supprimer l'actuel" toujours visible dans le menu contextuel|r
  |cffcccccc• Correction de la flèche ciblant le mauvais point de passage|r
  |cffcccccc• Le sélecteur d'appât affiche tous les points de passage actifs|r
  |cffcccccc• L'appât sélectionné persiste après /reload|r
  |cffcccccc• Affiche "Aller à <Zone>" quand l'appât est sur une autre carte|r
  |cffcccccc• Les étiquettes du menu affichent créature et zone|r

|cffffd700v1.0.0|r
  |cffcccccc• Statut des quêtes : /mj status, /mj way, /mj all, /mj clear|r
  |cffcccccc• Intégration TomTom pour la minicarte et la carte du monde|r
  |cffcccccc• Flèche directionnelle HUD (déplacer, verrouiller, taille)|r
  |cffcccccc• Overlay d'info-bulle pour les appâts : Disponible / Dépouillé aujourd'hui|r
  |cffcccccc• Localisation complète : 9 langues|r
  |cffcccccc• Icône et titre de l'addon ajoutés au TOC|r
  |cffcccccc• Correction de l'encodage de localisation (UTF-8)|r

|cffffd700v0.2.0|r
  |cffcccccc• Correction de l'erreur nil sur tooltip data.id (API héritée)|r
  |cffcccccc• Remplacement des séquences d'échappement octales dans les fichiers de localisation|r

|cffffd700v0.1.0|r
  |cffcccccc• Info-bulle d'appât : Disponible (vert) / Dépouillé aujourd'hui (rouge)|r
  |cffcccccc• Bouton de point de passage cliquable au survol de l'info-bulle|r
  |cffcccccc• TomTom changé de RequiredDeps en OptionalDeps|r
  |cffcccccc• Clés de localisation ajoutées pour les 9 langues|r]=]

_cl["esES"] = [=[
|cffffd700v2.0.0|r
  |cffcccccc• Dependencia de TomTom eliminada – puntos de ruta totalmente integrados|r
  |cffcccccc• Los puntos de ruta persisten tras /reload (SavedVariables)|r
  |cffcccccc• Iconos del minimapa y mapa del mundo usan la textura del addon|r
  |cffcccccc• El botón de punto de ruta en el tooltip ahora tiene fondo oscuro|r
  |cffcccccc• /mj clear actualiza inmediatamente el texto del botón|r
  |cffcccccc• Corregido error nil al limpiar por primera vez|r
  |cffcccccc• "Eliminar actual" siempre visible en el menú contextual|r
  |cffcccccc• Corregida la flecha rastreando el punto de ruta equivocado|r
  |cffcccccc• El selector de señuelo muestra todos los puntos de ruta activos|r
  |cffcccccc• El señuelo seleccionado persiste tras /reload|r
  |cffcccccc• Muestra "Ir a <Zona>" cuando el señuelo está en otro mapa|r
  |cffcccccc• Las etiquetas del menú muestran criatura y zona|r

|cffffd700v1.0.0|r
  |cffcccccc• Estado de misiones: /mj status, /mj way, /mj all, /mj clear|r
  |cffcccccc• Integración TomTom para minimapa y mapa del mundo|r
  |cffcccccc• Flecha HUD direccional (arrastrar, bloquear, tamaño)|r
  |cffcccccc• Overlay de tooltip para señuelos: Disponible / Desollado hoy|r
  |cffcccccc• Localización completa: 9 idiomas|r
  |cffcccccc• Icono y título del addon añadidos al TOC|r
  |cffcccccc• Corregida codificación de localización (UTF-8)|r

|cffffd700v0.2.0|r
  |cffcccccc• Corregido error nil en tooltip data.id (API heredada)|r
  |cffcccccc• Reemplazadas secuencias de escape octales en archivos de localización|r

|cffffd700v0.1.0|r
  |cffcccccc• Tooltip de señuelo: Disponible (verde) / Desollado hoy (rojo)|r
  |cffcccccc• Botón de punto de ruta clicable al pasar sobre el tooltip|r
  |cffcccccc• TomTom cambiado de RequiredDeps a OptionalDeps|r
  |cffcccccc• Claves de localización añadidas para los 9 idiomas|r]=]

_cl["esMX"] = _cl["esES"]

_cl["ruRU"] = [=[
|cffffd700v2.0.0|r
  |cffcccccc• Зависимость от TomTom удалена – путевые точки полностью встроены|r
  |cffcccccc• Путевые точки сохраняются после /reload (SavedVariables)|r
  |cffcccccc• Иконки миникарты и карты мира используют текстуру аддона|r
  |cffcccccc• Кнопка путевой точки в подсказке теперь имеет тёмный фон|r
  |cffcccccc• /mj clear немедленно обновляет текст кнопки|r
  |cffcccccc• Исправлена ошибка nil при первом очищении|r
  |cffcccccc• «Удалить текущий» всегда виден в контекстном меню|r
  |cffcccccc• Исправлено: стрелка отслеживала неверную точку после удаления|r
  |cffcccccc• Выбор приманки показывает все активные путевые точки|r
  |cffcccccc• Выбранная приманка сохраняется после /reload|r
  |cffcccccc• «Перейти к <Зона>» если приманка на другой карте|r
  |cffcccccc• Метки меню показывают существо и зону|r

|cffffd700v1.0.0|r
  |cffcccccc• Статус заданий: /mj status, /mj way, /mj all, /mj clear|r
  |cffcccccc• Интеграция TomTom для миникарты и карты мира|r
  |cffcccccc• Направляющая стрелка HUD (перетаскивание, блокировка, размер)|r
  |cffcccccc• Наложение подсказки для приманок: Доступно / Освежёвано сегодня|r
  |cffcccccc• Полная локализация: 9 языков|r
  |cffcccccc• Иконка и заголовок аддона добавлены в TOC|r
  |cffcccccc• Исправлена кодировка локализации (UTF-8)|r

|cffffd700v0.2.0|r
  |cffcccccc• Исправлена ошибка nil в tooltip data.id (устаревший API)|r
  |cffcccccc• Заменены восьмеричные escape-последовательности в файлах локализации|r

|cffffd700v0.1.0|r
  |cffcccccc• Подсказка приманки: Доступно (зелёный) / Освежёвано сегодня (красный)|r
  |cffcccccc• Кнопка путевой точки в подсказке приманки|r
  |cffcccccc• TomTom изменён с RequiredDeps на OptionalDeps|r
  |cffcccccc• Добавлены ключи локализации для 9 языков|r]=]

_cl["zhCN"] = [=[
|cffffd700v2.0.0|r
  |cffcccccc• 移除TomTom依赖 — 路径点完全内置|r
  |cffcccccc• 路径点在/reload后保持（SavedVariables）|r
  |cffcccccc• 小地图和世界地图图标使用插件贴图|r
  |cffcccccc• 提示框路径点按鈕现在有深色背景|r
  |cffcccccc• /mj clear立即更新浮层按鈕文字|r
  |cffcccccc• 修复首次清除时的nil错误|r
  |cffcccccc• 右键菜单中“移除当前”始终可见|r
  |cffcccccc• 修复删除后箭头追踪错误路径点的问题|r
  |cffcccccc• 右键诱饵选择器显示所有活跃路径点|r
  |cffcccccc• 所选诱饵在/reload后保持|r
  |cffcccccc• 所选诱饵在不同地图时显示“前往<区域>”|r
  |cffcccccc• 菜单标签显示生物和区域名称|r

|cffffd700v1.0.0|r
  |cffcccccc• 任务状态：/mj status、/mj way、/mj all、/mj clear|r
  |cffcccccc• 小地图和世界地图的TomTom集成|r
  |cffcccccc• HUD方向箭头（拖拽、锁定、大小）|r
  |cffcccccc• 诱饵提示框浮层：可用 / 今日已剥皮|r
  |cffcccccc• 完整本地化：9种语言|r
  |cffcccccc• 插件图标和标题添加至TOC|r
  |cffcccccc• 修复本地化编码（UTF-8字面量）|r

|cffffd700v0.2.0|r
  |cffcccccc• 修复tooltip data.id的nil错误（旧版API）|r
  |cffcccccc• 替换本地化文件中的八进制转义序列|r

|cffffd700v0.1.0|r
  |cffcccccc• 诱饵提示框：可用（绿色）/ 今日已剥皮（红色）|r
  |cffcccccc• 诱饵提示框上的可点击路径点按钮|r
  |cffcccccc• TomTom从RequiredDeps改为OptionalDeps|r
  |cffcccccc• 为所有9种语言添加本地化键|r]=]

_cl["zhTW"] = _cl["zhCN"]

_cl["koKR"] = [=[
|cffffd700v2.0.0|r
  |cffcccccc• TomTom 의존성 제거 – 경유지가 완전히 내장됨|r
  |cffcccccc• /reload 후에도 경유지 유지 (SavedVariables)|r
  |cffcccccc• 미니맵 및 세계 지도 아이콘이 애드온 텍스처 사용|r
  |cffcccccc• 툴팁 경유지 버튼에 어두운 배경 추가|r
  |cffcccccc• /mj clear 즉시 오버레이 버튼 텍스트 업데이트|r
  |cffcccccc• 첫 번째 지우기 시 nil 오류 수정|r
  |cffcccccc• 오른쪽 클릭 메뉴에서 "현재 제거" 항상 표시|r
  |cffcccccc• 경유지 제거 후 화살표가 잘못된 경유지를 추적하는 문제 수정|r
  |cffcccccc• 오른쪽 클릭 미끼 선택기에 모든 활성 경유지 표시|r
  |cffcccccc• 선택한 미끼가 /reload 후에도 유지됨|r
  |cffcccccc• 선택한 미끼가 다른 지도에 있을 때 "이동: <지역>" 표시|r
  |cffcccccc• 메뉴 레이블에 생물 및 지역 이름 표시|r

|cffffd700v1.0.0|r
  |cffcccccc• 임무 상태: /mj status, /mj way, /mj all, /mj clear|r
  |cffcccccc• 미니맵 및 세계 지도용 TomTom 연동|r
  |cffcccccc• HUD 방향 화살표 (드래그, 잠금, 크기)|r
  |cffcccccc• 미끼 툴팁 오버레이: 사용 가능 / 오늘 채집 완료|r
  |cffcccccc• 완전한 현지화: 9개 언어|r
  |cffcccccc• 애드온 아이콘 및 제목 TOC에 추가|r
  |cffcccccc• 현지화 인코딩 수정 (UTF-8 리터럴)|r

|cffffd700v0.2.0|r
  |cffcccccc• 툴팁 data.id의 nil 오류 수정 (레거시 API)|r
  |cffcccccc• 현지화 파일의 8진수 이스케이프 시퀀스 교체|r

|cffffd700v0.1.0|r
  |cffcccccc• 미끼 툴팁: 사용 가능 (초록) / 오늘 채집 완료 (빨강)|r
  |cffcccccc• 미끼 툴팁 위에 클릭 가능한 경유지 버튼|r
  |cffcccccc• TomTom을 RequiredDeps에서 OptionalDeps로 변경|r
  |cffcccccc• 9개 언어 모두에 현지화 키 추가|r]=]

_cl["itIT"] = [=[
|cffffd700v2.0.0|r
  |cffcccccc• Dipendenza da TomTom rimossa – punti di percorso completamente integrati|r
  |cffcccccc• I punti di percorso persistono dopo /reload (SavedVariables)|r
  |cffcccccc• Le icone della minimappa e della mappa del mondo usano la texture dell'addon|r
  |cffcccccc• Il pulsante del punto di percorso nel tooltip ha ora uno sfondo scuro|r
  |cffcccccc• /mj clear aggiorna immediatamente il testo del pulsante|r
  |cffcccccc• Corretto errore nil alla prima cancellazione|r
  |cffcccccc• "Rimuovi attuale" sempre visibile nel menu contestuale|r
  |cffcccccc• Corretto: freccia tracciava il punto sbagliato dopo la rimozione|r
  |cffcccccc• Il selettore di esca mostra tutti i punti di percorso attivi|r
  |cffcccccc• L'esca selezionata persiste dopo /reload|r
  |cffcccccc• Mostra "Vai a <Zona>" quando l'esca è su una mappa diversa|r
  |cffcccccc• Le etichette del menu mostrano creatura e zona|r

|cffffd700v1.0.0|r
  |cffcccccc• Stato missioni: /mj status, /mj way, /mj all, /mj clear|r
  |cffcccccc• Integrazione TomTom per minimappa e mappa del mondo|r
  |cffcccccc• Freccia HUD direzionale (trascina, blocca, dimensione)|r
  |cffcccccc• Overlay tooltip per esche: Disponibile / Scuoiato oggi|r
  |cffcccccc• Localizzazione completa: 9 lingue|r
  |cffcccccc• Icona e titolo dell'addon aggiunti al TOC|r
  |cffcccccc• Corretta codifica localizzazione (letterali UTF-8)|r

|cffffd700v0.2.0|r
  |cffcccccc• Corretto errore nil su tooltip data.id (API legacy)|r
  |cffcccccc• Sostituite sequenze di escape ottali nei file di localizzazione|r

|cffffd700v0.1.0|r
  |cffcccccc• Tooltip esca: Disponibile (verde) / Scuoiato oggi (rosso)|r
  |cffcccccc• Pulsante punto di percorso cliccabile al passaggio sul tooltip|r
  |cffcccccc• TomTom modificato da RequiredDeps a OptionalDeps|r
  |cffcccccc• Chiavi di localizzazione aggiunte per tutte le 9 lingue|r]=]

_cl["ptBR"] = [=[
|cffffd700v2.0.0|r
  |cffcccccc• Dependência do TomTom removida – pontos de percurso totalmente integrados|r
  |cffcccccc• Os pontos de percurso persistem após /reload (SavedVariables)|r
  |cffcccccc• Ícones do minimapa e do mapa do mundo usam a textura do addon|r
  |cffcccccc• O botão de ponto de percurso no tooltip agora tem fundo escuro|r
  |cffcccccc• /mj clear atualiza imediatamente o texto do botão|r
  |cffcccccc• Corrigido erro nil ao limpar pela primeira vez|r
  |cffcccccc• "Remover atual" sempre visível no menu de contexto|r
  |cffcccccc• Corrigido: seta rastreava o ponto de percurso errado após remoção|r
  |cffcccccc• O seletor de isca mostra todos os pontos de percurso ativos|r
  |cffcccccc• A isca selecionada persiste após /reload|r
  |cffcccccc• Mostra "Ir para <Zona>" quando a isca está em outro mapa|r
  |cffcccccc• Rótulos do menu mostram criatura e zona|r

|cffffd700v1.0.0|r
  |cffcccccc• Status de missões: /mj status, /mj way, /mj all, /mj clear|r
  |cffcccccc• Integração TomTom para minimapa e mapa do mundo|r
  |cffcccccc• Seta direcional HUD (arrastar, bloquear, tamanho)|r
  |cffcccccc• Sobreposição de tooltip para iscas: Disponível / Esfolado hoje|r
  |cffcccccc• Localização completa: 9 idiomas|r
  |cffcccccc• Ícone e título do addon adicionados ao TOC|r
  |cffcccccc• Codificação de localização corrigida (literais UTF-8)|r

|cffffd700v0.2.0|r
  |cffcccccc• Corrigido erro nil no tooltip data.id (API legada)|r
  |cffcccccc• Sequências de escape octais substituídas nos arquivos de localização|r

|cffffd700v0.1.0|r
  |cffcccccc• Tooltip de isca: Disponível (verde) / Esfolado hoje (vermelho)|r
  |cffcccccc• Botão de ponto de percurso clicável ao passar sobre o tooltip|r
  |cffcccccc• TomTom alterado de RequiredDeps para OptionalDeps|r
  |cffcccccc• Chaves de localização adicionadas para todos os 9 idiomas|r]=]

_cl["daDA"] = [=[
|cffffd700v2.0.0|r
  |cffcccccc• TomTom-afhængighed fjernet – waypoints fuldt integreret|r
  |cffcccccc• Waypoints bevares efter /reload (SavedVariables)|r
  |cffcccccc• Minimap- og verdenskortikoner bruger addon-tekstur|r
  |cffcccccc• Tooltip-waypointknap har nu mørk baggrund|r
  |cffcccccc• /mj clear opdaterer straks overlay-knapteksten|r
  |cffcccccc• Rettet nil-fejl ved første rydning|r
  |cffcccccc• "Fjern nuværende" altid synlig i højreklik-menuen|r
  |cffcccccc• Rettet: pilen sporede forkert waypoint efter fjernelse|r
  |cffcccccc• Højreklik-lokkevalg viser alle aktive waypoints|r
  |cffcccccc• Valgt lokkemiddel bevares efter /reload|r
  |cffcccccc• Viser "Gå til <Zone>" når lokkemiddel er på et andet kort|r
  |cffcccccc• Menuetiketter viser kreatur og zonenavn|r

|cffffd700v1.0.0|r
  |cffcccccc• Quest-status: /mj status, /mj way, /mj all, /mj clear|r
  |cffcccccc• TomTom-integration til minimap og verdenskort|r
  |cffcccccc• HUD-retningspil (træk, lås, størrelse)|r
  |cffcccccc• Lokkemiddel-tooltip: Tilgængelig / Skinnet i dag|r
  |cffcccccc• Fuld lokalisering: 9 sprog|r
  |cffcccccc• Addon-ikon og titel tilføjet til TOC|r
  |cffcccccc• Rettet lokaliserings-encoding (UTF-8 literals)|r

|cffffd700v0.2.0|r
  |cffcccccc• Rettet nil-fejl på tooltip data.id (legacy API)|r
  |cffcccccc• Oktale escape-sekvenser erstattet i lokaliseringsfiler|r

|cffffd700v0.1.0|r
  |cffcccccc• Lokkemiddel-tooltip: Tilgængelig (grøn) / Skinnet i dag (rød)|r
  |cffcccccc• Klikbar waypointknap ved lokkemiddel-tooltip|r
  |cffcccccc• TomTom ændret fra RequiredDeps til OptionalDeps|r
  |cffcccccc• Lokaliseringsknøgler tilføjet for alle 9 sprog|r]=]

MajesticChangelogLocales = _cl
MajesticChangelog = _cl[GetLocale()] or _cl["enUS"]
