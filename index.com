<!DOCTYPE html>
<html lang="gu">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>Smart Pet Digital ID • Emergency Tag</title>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
    body { background: #0f172a; min-height: 100vh; display: flex; justify-content: center; align-items: center; padding: 14px 10px; }
    
    .card {
      width: 100%;
      max-width: 410px;
      background: #ffffff;
      border-radius: 26px;
      overflow: hidden;
      box-shadow: 0 20px 45px rgba(0,0,0,0.45);
      border: 1px solid rgba(255,255,255,0.15);
      text-align: center;
    }

    /* Emergency Alert Header */
    .emergency-header {
      background: linear-gradient(135deg, #e11d48, #be123c);
      color: white;
      padding: 13px 16px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .live-status {
      display: inline-flex;
      align-items: center;
      gap: 7px;
      font-size: 11px;
      font-weight: 800;
      letter-spacing: 0.6px;
    }
    .live-dot {
      width: 8px;
      height: 8px;
      background: #4ade80;
      border-radius: 50%;
      animation: pulse 1.6s infinite;
    }
    @keyframes pulse {
      0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(74, 222, 128, 0.7); }
      70% { transform: scale(1); box-shadow: 0 0 0 8px rgba(74, 222, 128, 0); }
      100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(74, 222, 128, 0); }
    }
    .badge-id {
      background: rgba(255, 255, 255, 0.25);
      padding: 4px 10px;
      border-radius: 14px;
      font-size: 11px;
      font-weight: 800;
    }

    /* Hero Avatar Section */
    .hero {
      background: linear-gradient(180deg, #ffe4e6 0%, #ffffff 100%);
      padding: 22px 16px 12px;
      position: relative;
    }
    .avatar-wrapper {
      position: relative;
      width: 145px;
      height: 145px;
      margin: 0 auto 12px;
    }
    .pet-photo {
      width: 100%;
      height: 100%;
      border-radius: 50%;
      object-fit: cover;
      border: 4px solid #f43f5e;
      box-shadow: 0 10px 22px rgba(244,63,94,0.25);
      background: #e2e8f0;
      display: none;
    }
    .photo-placeholder {
      position: absolute;
      top: 0; left: 0; width: 100%; height: 100%;
      border-radius: 50%;
      background: #f1f5f9;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 44px;
      border: 4px solid #f43f5e;
    }
    .species-tag {
      position: absolute;
      bottom: 4px;
      right: 4px;
      background: #0f172a;
      width: 32px;
      height: 32px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 16px;
      box-shadow: 0 3px 6px rgba(0,0,0,0.3);
      z-index: 2;
    }
    .pet-name { font-size: 28px; font-weight: 800; color: #0f172a; text-transform: uppercase; }
    .pet-sub { display: inline-block; margin-top: 4px; padding: 4px 12px; background: #f1f5f9; color: #475569; font-size: 13px; font-weight: 700; border-radius: 20px; }

    /* Action Buttons */
    .actions { padding: 10px 18px 14px; display: flex; flex-direction: column; gap: 10px; }
    .btn { display: flex; align-items: center; justify-content: center; gap: 8px; padding: 14px; border-radius: 15px; text-decoration: none; font-size: 16px; font-weight: 800; color: white; cursor: pointer; border: none; transition: 0.1s; }
    .btn:active { transform: scale(0.97); }
    .btn-call { background: linear-gradient(135deg, #10b981, #059669); }
    .btn-wa { background: linear-gradient(135deg, #25d366, #16a34a); }
    .btn-gps { 
      background: linear-gradient(135deg, #2563eb, #1d4ed8);
      box-shadow: 0 4px 14px rgba(37, 99, 235, 0.35);
      animation: bounce 2s infinite;
    }
    @keyframes bounce {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-3px); }
    }

    /* Vaccination Banner */
    .vax-banner {
      margin: 0 18px 12px;
      padding: 10px 14px;
      border-radius: 14px;
      font-size: 13px;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
    }
    .vax-yes { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
    .vax-no { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }

    /* Details Grid */
    .info-card {
      margin: 0 18px 14px;
      background: #f8fafc;
      border-radius: 18px;
      border: 1px solid #e2e8f0;
      padding: 12px 16px;
      text-align: left;
    }
    .info-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 8px 0;
      border-bottom: 1px dashed #e2e8f0;
      font-size: 13.5px;
    }
    .info-row:last-child { border-bottom: none; }
    .lbl { color: #64748b; font-weight: 600; }
    .val { color: #0f172a; font-weight: 700; }

    /* Notes Box */
    .note-box {
      margin: 0 18px 16px;
      background: #fff1f2;
      border-left: 4px solid #f43f5e;
      border-radius: 10px;
      padding: 11px 14px;
      font-size: 13px;
      color: #9f1239;
      text-align: left;
      line-height: 1.4;
    }

    /* GPS Status Box */
    .gps-box {
      background: #f1f5f9;
      padding: 12px;
      font-size: 12px;
      font-weight: 600;
      color: #475569;
      border-top: 1px solid #e2e8f0;
    }
  </style>
</head>
<body>

<div class="card">
  <!-- Header -->
  <div class="emergency-header">
    <div class="live-status">
      <div class="live-dot"></div>
      EMERGENCY LOST PET ID
    </div>
    <div class="badge-id" id="dispId">TAG #101</div>
  </div>

  <!-- Hero Photo -->
  <div class="hero">
    <div class="avatar-wrapper">
      <div class="photo-placeholder" id="avatarPlaceholder">🐶</div>
      <img id="petImg" class="pet-photo" src="" alt="Pet Profile Photo">
      <div class="species-tag" id="speciesIcon">🐶</div>
    </div>
    <div class="pet-name" id="petName">COCO</div>
    <div class="pet-sub" id="petBreed">Indian • Dog</div>
  </div>

  <!-- Actions -->
  <div class="actions">
    <!-- Easy 1-Tap Location Button -->
    <button class="btn btn-gps" id="btnGps" onclick="sendLocationNow()">
      📍 શેર લાઇવ લોકેશન (WhatsApp)
    </button>
    <a id="btnCall" href="#" class="btn btn-call">📞 Call Parents Now</a>
    <a id="btnWa" href="#" class="btn btn-wa">💬 WhatsApp Parents</a>
  </div>

  <!-- Vaccination -->
  <div id="vaxBox" class="vax-banner vax-yes">
    💉 Fully Vaccinated (રસીકરણ થયેલ છે)
  </div>

  <!-- Pet Details -->
  <div class="info-card">
    <div class="info-row">
      <span class="lbl">🐾 જાતિ / Gender:</span>
      <span class="val" id="petGender">Male ♂</span>
    </div>
    <div class="info-row">
      <span class="lbl">👨‍👩‍👧 Parents / વાલી:</span>
      <span class="val" id="parentName">Divya</span>
    </div>
    <div class="info-row">
      <span class="lbl">📍 City / રહેઠાણ:</span>
      <span class="val" id="ownerCity">Surat</span>
    </div>
  </div>

  <!-- Note -->
  <div class="note-box" id="medicalNote">
    <b>⚠️ મહત્વપૂર્ણ નોંધ:</b> Friendly
  </div>

  <!-- Status -->
  <div class="gps-box" id="gpsStatus">
    💡 "શેર લાઇવ લોકેશન" દબાવીને માલિકને કરંટ લોકેશન મોકલો
  </div>
</div>

<script>
  let targetPhone = "";
  let petDisplayName = "COCO";

  const params = new URLSearchParams(window.location.search);
  const currentId = (params.get('id') || '101').trim();
  document.getElementById("dispId").innerText = "TAG #" + currentId;

  const sheetUrl = "https://docs.google.com/spreadsheets/d/1-5xv254drMlUyuT1-gcFY503b5AXNF3D0nge50wc8A0/export?format=csv";

  fetch(sheetUrl)
    .then(res => res.text())
    .then(csv => {
      const lines = csv.split(/\r?\n/);
      let foundRow = null;

      for (let i = 1; i < lines.length; i++) {
        const row = lines[i].split(',').map(item => item ? item.trim().replace(/^"|"$/g, '') : '');
        if (row[0] && row[0] === currentId) {
          foundRow = row;
          break;
        }
      }

      if (foundRow) {
        petDisplayName = foundRow[1] || 'COCO';
        document.getElementById("petName").innerText = petDisplayName;

        const breed = foundRow[2] || 'Indian';
        const isCat = breed.toLowerCase().includes("cat") || breed.toLowerCase().includes("biladi");
        document.getElementById("speciesIcon").innerText = isCat ? "🐱" : "🐶";
        document.getElementById("petBreed").innerText = `${breed} • ${isCat ? 'Cat' : 'Dog'}`;

        document.getElementById("parentName").innerText = foundRow[3] || 'Divya';
        
        // Gender (Column E)
        const gText = (foundRow[4] || 'Male').toLowerCase();
        document.getElementById("petGender").innerText = (gText.includes("f") || gText.includes("female")) ? "Female ♀" : "Male ♂";

        // Vaccination (Column F)
        const vText = (foundRow[5] || 'Yes').toLowerCase();
        const vBox = document.getElementById("vaxBox");
        if (vText.includes("no") || vText.includes("નથી")) {
          vBox.className = "vax-banner vax-no";
          vBox.innerHTML = "⚠️ Vaccination Pending / રસીકરણ બાકી છે";
        } else {
          vBox.className = "vax-banner vax-yes";
          vBox.innerHTML = "💉 Fully Vaccinated (રસીકરણ થયેલ છે)";
        }

        // Phone Setup (Column G)
        let ph = (foundRow[6] || '9664951873').replace(/[^0-9]/g, '');
        if (ph.length === 10) ph = "91" + ph;
        targetPhone = ph;
        document.getElementById("btnCall").href = "tel:" + ph;
        document.getElementById("btnWa").href = `https://wa.me/${ph}?text=Hello, mane tamaro pet ${petDisplayName} malyo chhe.`;

        // City & Note (Columns H & I)
        document.getElementById("ownerCity").innerText = foundRow[7] || 'Surat';
        document.getElementById("medicalNote").innerHTML = `<b>⚠️ મહત્વપૂર્ણ નોંધ:</b> ${foundRow[8] || 'Friendly'}`;

        // Photo (Column J - Index 9)
        let rawPhoto = foundRow[9] ? foundRow[9].trim() : "";
        
        // જો Column J ખાલી હોય તો અન્ય કોલમમાં ફોટો લિંક શોધી લેશે
        if (!rawPhoto) {
          for (let k = 0; k < foundRow.length; k++) {
            const val = foundRow[k].trim();
            if (val.includes("ibb.co") || val.includes("drive.google.com") || (val.startsWith("http") && (val.includes(".jpg") || val.includes(".png") || val.includes(".jpeg")))) {
              rawPhoto = val;
              break;
            }
          }
        }

        if (rawPhoto) {
          // ImgBB Link conversion
          if (rawPhoto.includes("ibb.co/") && !rawPhoto.includes("i.ibb.co/")) {
            const idMatch = rawPhoto.split("ibb.co/")[1]?.split("/")[0];
            if (idMatch) rawPhoto = `https://i.ibb.co/${idMatch}/image.jpg`;
          } else if (rawPhoto.includes("drive.google.com")) {
            // Google Drive conversion
            const dId = rawPhoto.match(/\/d\/([a-zA-Z0-9_-]+)/) || rawPhoto.match(/id=([a-zA-Z0-9_-]+)/);
            if (dId && dId[1]) rawPhoto = `https://lh3.googleusercontent.com/d/${dId[1]}`;
          }

          const img = document.getElementById("petImg");
          img.src = rawPhoto;
          img.onload = () => {
            img.style.display = "block";
            document.getElementById("avatarPlaceholder").style.display = "none";
          };
          img.onerror = () => {
            document.getElementById("avatarPlaceholder").innerText = isCat ? "🐱" : "🐶";
          };
        }
      }
    })
    .catch(e => console.log(e));

  // ૧-ક્લિક સુપર ફાસ્ટ લોકેશન શેરિંગ
  function sendLocationNow() {
    const s = document.getElementById("gpsStatus");
    const btn = document.getElementById("btnGps");

    if (!("geolocation" in navigator)) {
      alert("તમારા ફોનમાં GPS સપોર્ટ નથી.");
      return;
    }

    btn.innerText = "⏳ લોકેશન મેળવી રહ્યું છે...";
    s.innerText = "⏳ GPS સિગ્નલ ચકાસી રહ્યું છે, કૃપા કરીને Allow કરો...";

    navigator.geolocation.getCurrentPosition(
      (pos) => {
        const lat = pos.coords.latitude;
        const lon = pos.coords.longitude;
        const mapsUrl = `https://www.google.com/maps?q=${lat},${lon}`;
        
        btn.innerText = "✅ WhatsApp ઓપન થઈ રહ્યું છે...";
        s.innerText = "✅ લોકેશન મળી ગયું! WhatsApp પર મોકલાઈ રહ્યું છે...";
        s.style.color = "#15803d";

        if (targetPhone) {
          const text = encodeURIComponent(`🚨 EMERGENCY ALERT: મને તમારો પાલતુ પેટ (${petDisplayName}) મળ્યો છે!\n📍 મારી કરંટ લાઇવ લોકેશન આ રહી:\n${mapsUrl}`);
          window.location.href = `https://wa.me/${targetPhone}?text=${text}`;
        }
      },
      (err) => {
        btn.innerText = "📍 શેર લાઇવ લોકેશન (WhatsApp)";
        s.innerText = "⚠️ લોકેશન પરમિશન બ્લોક છે. બ્રાઉઝરમાં Allow કરો.";
        s.style.color = "#b91c1c";
        alert("કૃપા કરીને લોકેશનની પરમિશન Allow (મંજૂરી) આપો જેથી માલિકને તમારું લોકેશન મળી શકે.");
      },
      { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 }
    );
  }
</script>

</body>
</html>
