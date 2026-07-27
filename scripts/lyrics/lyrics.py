#!/usr/bin/env python3
import sys
import urllib.request
import urllib.parse
import json
import re

def _romanize_urdu(text: str) -> str:
    urdu_word_map = {
        "ہنگامہ": "Hungama", "ہے": "hai", "کیوں": "kyon", "برپا": "barpa",
        "تھوڑی": "thodi", "سی": "si", "جو": "jo", "پی": "pee", "لی": "lee", "لیے": "liye",
        "ڈاکا": "daka", "تو": "to", "نہیں": "nahin", "ڈالا": "dala", "چوری": "chori", "توابھی": "to abhi",
        "ساقی": "saqi", "جام": "jaam", "میرا": "mera", "میری": "meri", "میرے": "mere", "دل": "dil",
        "محبت": "mohabbat", "عشق": "ishq", "خدا": "khuda", "تم": "tum", "آپ": "aap", "ہم": "hum",
        "وہ": "woh", "یہ": "yeh", "کیا": "kya", "کون": "kaun", "کبھی": "kabhi", "اب": "ab",
        "جب": "jab", "تاب": "taab", "غم": "gham", "شام": "shaam", "شب": "shab", "حسرت": "hasrat",
        "نظر": "nazar", "پل": "pal", "زندگی": "zindagi", "دنیا": "duniya", "دُنیا": "duniya",
        "شمع": "shama", "پروانہ": "parwana", "مست": "mast", "مستی": "masti", "رات": "raat",
        "بات": "baat", "ساتھ": "saath", "پاس": "paas", "دور": "door", "نور": "noor", "حور": "hoor",
        "سرور": "suroor", "میخانہ": "maikhana", "شراب": "sharab", "نشہ": "nasha", "خودی": "khudi",
        "بے": "be", "نام": "naam", "یا": "yaa", "کا": "ka", "کی": "ki", "کے": "ke",
        "کو": "ko", "سے": "se", "میں": "mein", "پر": "par", "اور": "aur", "نہ": "nah", "بھی": "bhi",
        "ہو": "ho", "ہی": "hi", "تھا": "tha", "تھی": "thi", "تھے": "the", "گئی": "gayi", "گئے": "gaye",
        "گیا": "gaya", "رہا": "raha", "رہی": "rahi", "رہے": "rahe", "کر": "kar", "کرنے": "karne",
        "آیا": "aaya", "آئی": "aayi", "آئے": "aaye", "کہا": "kaha", "سنا": "suna", "دیکھا": "dekha"
    }

    char_map = {
        'ا': 'a', 'آ': 'aa', 'ب': 'b', 'پ': 'p', 'ت': 't', 'ٹ': 't', 'ث': 's',
        'ج': 'j', 'چ': 'ch', 'ح': 'h', 'خ': 'kh', 'د': 'd', 'ڈ': 'd', 'ذ': 'z',
        'ر': 'r', 'ڑ': 'r', 'ز': 'z', 'ژ': 'zh', 'س': 's', 'ش': 'sh', 'ص': 's',
        'ض': 'z', 'ط': 't', 'ظ': 'z', 'ع': 'a', 'غ': 'gh', 'ف': 'f', 'ق': 'q',
        'ک': 'k', 'گ': 'g', 'ل': 'l', 'م': 'm', 'ن': 'n', 'ں': 'n', 'و': 'o',
        'ہ': 'h', 'ھ': 'h', 'ی': 'y', 'ے': 'e', 'ئ': 'i', 'ء': '', 'ۃ': 'h',
        'َ': 'a', 'ِ': 'i', 'ُ': 'u', 'ً': 'an', 'ٍ': 'in', 'ٌ': 'un', 'ّ': '', 'ْ': ''
    }

    words = text.split()
    res_words = []
    for w in words:
        clean_w = re.sub(r'[^\w\s\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF]', '', w)
        p_before = w[:w.find(clean_w)] if clean_w and w.find(clean_w) > 0 else ""
        p_after = w[w.find(clean_w) + len(clean_w):] if clean_w else ""

        if clean_w in urdu_word_map:
            trans = urdu_word_map[clean_w]
            res_words.append(p_before + trans + p_after)
        elif w in urdu_word_map:
            res_words.append(urdu_word_map[w])
        else:
            w_chars = [char_map.get(ch, ch) for ch in clean_w]
            fallback_trans = "".join(w_chars)
            res_words.append(p_before + fallback_trans + p_after)

    return " ".join(res_words)

def _romanize_non_bengali(text: str) -> str:
    # Check for Urdu / Arabic script
    if any('\u0600' <= c <= '\u06FF' or '\u0750' <= c <= '\u077F' or '\u08A0' <= c <= '\u08FF' or '\uFB50' <= c <= '\uFDFF' for c in text):
        return _romanize_urdu(text)

    if not any('\u0900' <= c <= '\u097F' for c in text):
        return text

    nukta_map = {
        'क़': 'क', 'ख़': 'ख', 'ग़': 'ग', 'ज़': 'ज', 'ड़': 'ड', 'ढ़': 'ढ', 'फ़': 'फ', 'य़': 'य',
        'क़': 'क', 'ख़': 'ख', 'ग़': 'ग', 'ज़': 'ज', 'ड़': 'ड', 'ढ़': 'ढ', 'फ़': 'फ', 'य़': 'य',
        '़': ''
    }
    for orig, rep in nukta_map.items():
        text = text.replace(orig, rep)

    vowels = {
        'अ':'a', 'आ':'aa', 'इ':'i', 'ई':'ee', 'उ':'u', 'ऊ':'oo', 'ऋ':'ri',
        'ए':'e', 'ऐ':'ai', 'ओ':'o', 'औ':'au', 'अं':'an', 'अः':'ah'
    }
    matras = {
        'ा':'aa', 'ि':'i', 'ी':'ee', 'ु':'u', 'ू':'oo', 'ृ':'ri',
        'ے':'e', 'े':'e', 'ै':'ai', 'ो':'o', 'ौ':'au', 'ं':'n', 'ः':'h', 'ँ':'n', '्':''
    }
    consonants = {
        'क':'k', 'क़':'k', 'ख':'kh', 'ख़':'kh', 'ग':'g', 'ग़':'g', 'घ':'gh', 'ङ':'ng',
        'च':'ch', 'छ':'chh', 'ज':'j', 'ज़':'z', 'झ':'jh', 'ञ':'ny',
        'ट':'t', 'ठ':'th', 'ड':'d', 'ढ':'dh', 'ण':'n',
        'त':'t', 'थ':'th', 'द':'d', 'ध':'dh', 'न':'n',
        'प':'p', 'फ':'ph', 'फ़':'f', 'ब':'b', 'भ':'bh', 'म':'m',
        'य':'y', 'र':'r', 'ल':'l', 'व':'v', 'श':'sh',
        'ष':'sh', 'स':'s', 'ह':'h', 'ड़':'d', 'ढ़':'dh'
    }

    res = []
    i = 0
    n = len(text)
    while i < n:
        char = text[i]
        if '\u0980' <= char <= '\u09FF':
            res.append(char)
            i += 1
            continue
        
        if char in consonants:
            base = consonants[char]
            next_c = text[i+1] if i + 1 < n else ''
            if next_c in matras:
                if next_c == '्':
                    res.append(base)
                else:
                    res.append(base + matras[next_c])
                i += 2
            else:
                if i + 1 < n and text[i+1] not in (' ', '\n', '\t', ',', '.', '/', '!', '?', '|', '-'):
                    res.append(base + 'a')
                else:
                    res.append(base)
                i += 1
        elif char in vowels:
            res.append(vowels[char])
            i += 1
        elif char in matras:
            res.append(matras[char])
            i += 1
        else:
            res.append(char)
            i += 1
            
    return ''.join(res)

def _parse_lrc(lrc_text: str) -> list:
    lines = []
    for raw in lrc_text.splitlines():
        raw = raw.strip()
        if not raw:
            continue
        try:
            tag_end = raw.index("]")
            time_str = raw[1:tag_end]
            text = raw[tag_end + 1:].strip()
            mins, secs = time_str.split(":")
            timestamp = int(mins) * 60 + float(secs)
            lines.append({"time": timestamp, "text": _romanize_non_bengali(text)})
        except Exception:
            continue
    return sorted(lines, key=lambda x: x["time"])

import os

def _check_local_lrc(title: str, artist: str) -> str:
    home = os.path.expanduser("~")
    dirs = [
        os.path.join(home, ".config", "quickshell", "lyrics"),
        os.path.join(home, ".cache", "quickshell", "lyrics")
    ]
    filename_candidates = [
        f"{artist} - {title}.lrc",
        f"{title} - {artist}.lrc",
        f"{title}.lrc"
    ]
    for d in dirs:
        if not os.path.exists(d):
            continue
        for fname in filename_candidates:
            path = os.path.join(d, fname)
            if os.path.isfile(path):
                try:
                    with open(path, "r", encoding="utf-8") as f:
                        return f.read()
                except Exception:
                    pass
    return ""

def _parse_plain_lyrics(plain_text: str, duration: float) -> list:
    raw_lines = [l.strip() for l in plain_text.splitlines() if l.strip()]
    if not raw_lines:
        return []
    dur = float(duration) if duration and float(duration) > 0 else 180.0
    
    start_offset = max(6.0, dur * 0.08)
    end_offset = max(5.0, dur * 0.05)
    effective_dur = max(10.0, dur - start_offset - end_offset)
    
    weights = [max(1, len(line.split())) for line in raw_lines]
    total_weight = sum(weights)
    lines = []
    current_time = start_offset
    
    for i, text in enumerate(raw_lines):
        lines.append({"time": round(current_time, 2), "text": _romanize_non_bengali(text)})
        line_duration = (weights[i] / total_weight) * effective_dur
        current_time += line_duration
        
    return lines

def _clean_title(title: str) -> str:
    # Strip tab notification numbers like (22), (1), [5]
    t = re.sub(r'^\s*[\(\[]\d+[\)\]]\s*', '', title)
    # Strip prefix tags like Lyrical:, Video:, Full Video:, Audio:, Official Video:
    t = re.sub(r'^\s*(lyrical|full video|official video|video|audio|full song|hd|4k|track)\s*:\s*', '', t, flags=re.IGNORECASE)
    t = re.sub(r'[\(\[\{].*?[\)\]\}]', '', t)
    parts = [p.strip() for p in re.split(r'[\|]', t) if p.strip()]
    if parts:
        t = parts[0]
    t = re.sub(r'-\s*YouTube.*$', '', t, flags=re.IGNORECASE)
    t = re.sub(r'\b(song|full song|audio song|video|hd|4k|lyric|lyrics)\b', '', t, flags=re.IGNORECASE)
    return t.strip(' -|[]()')

def _clean_title_and_artist(title: str, artist: str) -> tuple:
    c_title = _clean_title(title)
    c_artist = artist.strip()

    if not c_artist and '-' in c_title:
        parts = [p.strip() for p in c_title.split('-') if p.strip()]
        if len(parts) >= 2:
            c_title = parts[0]
            c_artist = parts[1].split('|')[0].strip()

    return c_title, c_artist

def _is_match(d: dict, title: str, artist: str, require_synced: bool = False) -> bool:
    has_synced = bool(d.get("syncedLyrics"))
    has_plain = bool(d.get("plainLyrics"))
    if not has_synced and not has_plain:
        return False
    if require_synced and not has_synced:
        return False

    r_title  = (d.get("trackName")  or "").lower()
    r_artist = (d.get("artistName") or "").lower()
    t = title.lower()
    a = artist.lower()
    title_words = [w for w in t.split() if len(w) > 2]
    title_match = (t in r_title or r_title in t or
                   any(word in r_title for word in title_words))
    if not a:
        return title_match
    artist_match = (a in r_artist or r_artist in a or
                    any(word in r_artist for word in a.split() if len(word) > 2))
    return title_match or artist_match

def fetch_lrclib(title: str, artist: str, duration: float) -> tuple:
    c_title, c_artist = _clean_title_and_artist(title, artist)

    # First check local .lrc file override (~/.config/quickshell/lyrics/ or ~/.cache/quickshell/lyrics/)
    local_lrc_content = _check_local_lrc(c_title, c_artist)
    if local_lrc_content:
        local_lines = _parse_lrc(local_lrc_content)
        if local_lines:
            return local_lines, True
    urls = []
    if c_artist:
        query_str = f"{c_title} {c_artist}"
        urls.extend([
            f"https://lrclib.net/api/get?track_name={urllib.parse.quote(c_title)}&artist_name={urllib.parse.quote(c_artist)}&duration={int(duration)}",
            f"https://lrclib.net/api/search?track_name={urllib.parse.quote(c_title)}&artist_name={urllib.parse.quote(c_artist)}",
            f"https://lrclib.net/api/search?q={urllib.parse.quote(query_str)}",
        ])
    urls.append(f"https://lrclib.net/api/search?q={urllib.parse.quote(c_title)}")
    
    # Word count fallback for long video titles
    words = c_title.split()
    if len(words) > 3:
        urls.append(f"https://lrclib.net/api/search?q={urllib.parse.quote(' '.join(words[:4]))}")
        urls.append(f"https://lrclib.net/api/search?q={urllib.parse.quote(' '.join(words[:3]))}")

    plain_fallback_item = None

    for url in urls:
        try:
            with urllib.request.urlopen(url, timeout=10) as r:
                data = json.loads(r.read().decode())
            if isinstance(data, dict):
                data = [data]
            if isinstance(data, list):
                matched_synced = next((d for d in data if d.get("syncedLyrics") and _is_match(d, c_title, c_artist, require_synced=True)), None)
                if matched_synced and matched_synced.get("syncedLyrics"):
                    lines = _parse_lrc(matched_synced["syncedLyrics"])
                    if lines:
                        return lines, True

                if not plain_fallback_item:
                    matched_plain = next((d for d in data if d.get("plainLyrics") and _is_match(d, c_title, c_artist, require_synced=False)), None)
                    if matched_plain:
                        plain_fallback_item = matched_plain
        except Exception:
            continue

    if plain_fallback_item:
        if plain_fallback_item.get("syncedLyrics"):
            return _parse_lrc(plain_fallback_item["syncedLyrics"]), True
        if plain_fallback_item.get("plainLyrics"):
            return _parse_plain_lyrics(plain_fallback_item["plainLyrics"], duration), False

    return [], False

def main():
    if len(sys.argv) < 4:
        print("no_info", flush=True)
        sys.exit(0)
    title    = sys.argv[1]
    artist   = sys.argv[2]
    duration = float(sys.argv[3])
    if not title:
        print("no_info", flush=True)
        sys.exit(0)
    lines, is_synced = fetch_lrclib(title, artist, duration)
    if not lines:
        print("not_found", flush=True)
        sys.exit(0)
    parts = []
    for line in lines:
        parts.append(str(line["time"]))
        parts.append(line["text"].replace("§", ""))
    parts.append("synced_ok" if is_synced else "plain_ok")
    print("§".join(parts), flush=True)

if __name__ == "__main__":
    main()