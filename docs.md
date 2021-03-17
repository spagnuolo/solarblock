# Hyperledger Fabric: Solarblock
Frankfurt University of Applied Sciences  
Blockchain im Internet of things - WS 20/21


Edited by
* Kniss, Henry (1226278)
* Schiller, Markus
* v
* g

## Contents
1. Einleitung
1. Grundlagen
1. Szenario
1. System Design
1. System Implementation 
1. Validation
1. Conclusion

## 1 Einleitung
Die vorliegende Ausarbeitung dokumentiert die  Erstellung einer Hyperledger-Fabric Applikation zum Management eines Marktes für Energie im Rahmen des Kurses "Blockchain im Internet of Things" im Wintersemester 20/21 an der "Frankfurt University Of Applied Sciences". Zum Zwecke der Übersichtlichkeit Gliedert sich das vorliegende Dokument in Sechs Kapitel. "Einleitung" gibt einen Überblick über unsere Arbeitsweise, Team-Hierarchie sowie unser Szenario. im Kapitel "Foundation" werfen wir einen Blick auf den Aufbau und die Möglichkeiten welche Hyperledger Fabric bietet , während wir bereits zu differenzieren versuchen welche davon im Rahmen des "System Designs" für das von uns gewählte Szenario relevant sind. In welchem wir dann auch unsere Gründe für die von uns getroffenen Designentscheidungen erläutern.Dazu präsentieren wir einige der von uns erstellten Diagramme und zeigen deren nutzen als Leitbild bei der Finalisierung unseres Projektes. "System Implementation" befasst sich dann schließlich mit der technischen Details unserer Applikation während wir hier ebenfalls dem Leser diverse Funktionsweisen anhand von Codefragementen nahe bringen gehen wir darüber hinaus auf einige Problematiken ein welche uns spezielle Schwierigkeiten bei der Implementierung machten und wie wir diese lösten. "Validation" (DAS FÜGT HENRY EIN SOBALD ER WEISS WAS ZUM FICK IN DIESEM KAPITEL STEHEN SOLL). In "Fazit" reflektieren wir schließlich die Gesamtheit des Projekts. Wir kommentieren unsere Arbeit als Gruppe und unsere Meinung von Hyperledger Fabric und unserem Szenario. Darüber hinaus geben wir einen Ausblick auf Features welche wir mit mehr Zeit gerne implementiert hätten und Probleme die wir gerne noch beheben würden.

### Organisation

Die Teamarbeit erfolgte in einer sehr flachen Hierarchie. Uns war im Verlauf der Ausarbeitung sehr viel daran gelegen dass alle sich einig über die zu erfolgenden Schritte  waren. Um dies zu erreichen planten wir drei regelmäßige Treffen pro Wochen in welchen wir unser Vorgehen bis zum jeweils nächsten planten , immer mit dem erklärten Ziel die von uns als Sprint-Ziele deklarierten Ziele zu erreichen. Bei diesen Treffen war es irrelevant wie viel Fortschritt von den jeweiligen Team-Mitgliedern zu diesem Zeitpunkt erarbeitet wurde, es ging hauptsächlich um den regelmäßigen Kontakt und das Einvernehmen über das weitere vorgehen.a Zu jedem dieser Treffen wurde darüber hinaus ein Protokoll gefertigt welches jedem Mitglied zur Verfügung stand um ggf. Verhinderten die Möglichkeit zu eröffnen sich trotzdem den neusten Stand zu bringen. Darüber hinaus versuchten wenn möglich klar Aufgabenzuteilung zu vermeiden , wir ordneten gewissen Features stattdessen eine Priorität zu und ließen diejenigen daran Arbeiten welche gerade die größte Motivation auf die jeweilige Task hatten. Anschließend kombinierten wir die Ergebnisse  als Gruppe. Der Hintergedanke hierbei war jener das Menschen natürlicherweise die besten Ergebnisse Liefern wenn Sie an Dingen arbeiten an welchen Sie Spaß haben.

### Tools
Zur Organisation, Kommunikation, Code´-Verarbeitung und Versionskontrolle.

1. WhatsApp
1. Discord
1. Git-Hub
1. Zoom
1. Google Drive

WhatsApp diente zur regelmäßigen und formlosen Absprache untereinander, zum Austausch von Ideen und um andere über akute Probleme zu informieren oder kurzfristige Terminabsprachen zu treffen. Auf Discord hingegen betrieben wir einen Server, hauptsächlich um konzentriert Links zu nützlichen quellen zu bündeln und sekundär um einen weiteren Kommunikationskanäle gewährleisten zu können. Darüber hinaus verwendeten wir jedoch Zoom für regelmäßige Videocall-Meetings. Google Drive, also Cloudstorage-Anbieter, diente uns zur Sammlung sämtlicher nicht Quellcode oder Netzwerk bezogener Daten, hier finden sich in einem Geteilten Ordner die Sammlung unsere Sprintreviews, Präsentation und erstellter Diagramme. Unseren Quellcode schließlich managten wir über das Versionmanagementtool Git-Hub in welchem auch unsere offenen Tasks verfolgt wurden. Die Wahl der verwendeten IDE blieb schließlich jedem selbst überlassen.

## 2 Grundlagen
In diesem Kapitel wollen wir uns dem grundlegenden Aufbau und der Funktionsweise von Hyperledger Fabric widmen. Dabei setzen wir einen speziellen Fokus jene die für die Entwicklung unserer Applikation relevant sind. Zu diesem Zweck stützen wir uns auf die Ausarbeitung " Hyperledger Fabric: A Distributed Operating System for Permissoned Blockchains"

## 3 Szenario
Im Rahmen des folgenden Kapitels werden wir den Kontext darlegen in welchem unsere Applikation entwickelt wurde. Im Vorfeld des ersten Sprints hielten wir ein Problemstellung fest welche wir mit Hilfe einer Blockchain unter Hyperledger Fabric zu lösten. Wir erläutern nunmehr die Abgrenzungen des Szenarios, legen in abstrahierter Form die Probleme da die es zu lösen galt und unsere  Begründung wieso wir dieses Szenario als Beispiel ausgewählt haben.  Einen ex post wertenden Blick auf jenes Rationalem liefern wir ergänzend in Kapitel 5.

### Abgrenzung des Szenarios
Das Kernkonzept welchem sich unser Szenario widmet ist die Solarenergie. Wir haben uns zum Ziel gesetzte einen privaten, angebotsbasierten Markt für Solarenergie zu schaffen. Dieser soll im wesentlichen den Teilnehmern ermöglichen im Rahmen des Privathaushaltes via Solarpaneelen generierten Strom Mitbürgern entgeltlich zur Verfügung zu stellen, bzw. ihren Bedarf aus der Solarenergie ihrer Mitbürger zu decken. Die Grundlage für einen solchen Austausch stellt das lokale Stromnetz da. Dies bindet den jeweiligen Netzbetreiber ein welcher als Broker agiert der ebenfalls Solarenergie ankaufen kann wenn sich dafür sonst kein privater Abnehmer findet, jedoch selbst keine eigenen Angebote ins Netzwerk emittiert.

### Teilnehmer und deren Motivation
Hiermit lassen sich also zwei Teilnehmergruppen identifizieren welche verschiedene Interessen besitzen. Für beide lässt sich als Motivation entsprechen der grundlegende Hang des Homo oeconomicus\footnote{Homo oeconomicus beschreibt in den Wirtschaftswissenschaften das Axiom eines Akteurs welcher im ökonomsichen Gesamtkonstrukt steets nutzenmaximiert handelt} zur Profitmaximierung festhalten, auch wenn diese auf unterschiedlichen wegen erreicht wird. Die privaten Haushalte welche in das System einsteigen erhalten die Möglichkeit nicht genutzter Energie in Kapital umzusetzen, dies geschieht durch die entgeltliche zur Nutzungstellung dieser Energie gegenüber der anderen Teilnehmer.  Mit der weiteren Intention dass andere Teilnehmer auf diese weise günstiger als auf dem herkömmlicher Wege an eben selbige Energie kommen. Die Motivation welche den Netzbetreiber in diesen Konstrukt treibt ist zwar in ihrer Natur auch Profitorientiert geartet, erreicht die Profitoptimierung jedoch eher auf sekundäre Art und weise.  Ein solches Netzwerk bietet zwei Vorteile für den Netzbetreiber indem es zum einen die Möglichkeit bietet geringere Defizite in der Energieversorgung durch den Ankauf von Strom aus dem privaten Netz zu decken. Zum anderen erreichen wir auf diese Art eine Entlastung der Verteilernetze da der Strom in der Tendenz eher lokal bleibt. Wenn wir unsere Aufmerksamkeit jedoch einmal von den Teilnehmern weg lenken können wir darüber hin aus jedoch noch einige Vorteile erwägen welche als gesamtgesellschaftliches Interesse klassifizierbar sind. So begünstigen und fördern wir mit einem solchen  Konstrukt die Unabhängigkeit der Teilnehmenden Haushalte von etablierten Netzbetreibern und dadurch die Autarkie dieses Haushalte. Im weiteren würde eine großflächige Entwicklung zu einer solchen solarbasierten Technik umwelttechnisch langfristig positive Auswirkungen besitzen.

### Probleme
Das hier kommt zur Validation!


## 4 System Design
Umstrukturierung
...
Bild von der Architektur
Netzwerkaufbau (Komponenten, Ports, Container)
Interaktion der einzelnen Komponenten

## 5 System Implementation 
...

## 6 Validation
Validation and Evaluation

Welche Lösungen und Antworten wurden gefunden?
Welche Probleme sind aufgetreten und wie wurden sie gelöst?
Ist alles aus unserem Szenario und Vorstellungen eingetroffen? Was nicht?
Was haben wir neues und interessantes festgestellt, während wir mit der Technologie gearbeitet haben?

## 7 Conclusion
Conclusion und Diskussion

Was für Auswirkungen haben unsere Ergebnisse aus der Validation?
Bestätigen unser Resultate das Szenario?
Sehen wir Muster? (Blockchain so vielleicht gar nicht anwendbar?)
Wie wirkt sich das auf unser Wissen aus, dass wir davor hatten?
Sollte man mehr in diese Richtung forschen? (Falls ja: was und warum)
Ist Blockchain (Fabric) schon reif genug?

Das was uns an meisten überrascht hat, ist meist das wichtigste/interessanteste.

(Mit dieser Sektion wird meist nach mehr Geld und Unterstützung für weiter Forschung gefragt 😅)
