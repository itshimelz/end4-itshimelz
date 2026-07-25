<div align="center">

# 💠 end4-itshimelz

**[@pctrade](https://github.com/pctrade)-এর [end4-pC](https://github.com/pctrade/end4-pC) প্রজেক্টের একটি কাস্টমাইজড ফর্ক**  
*(মূলত [@end-4](https://github.com/end-4)-এর [illogical-impulse](https://github.com/end-4/dots-hyprland) থেকে তৈরি)*

মূল প্রজেক্ট: **[@end-4](https://github.com/end-4)** • আপস্ট্রিম ফর্ক: **[@pctrade](https://github.com/pctrade)** • কাস্টমাইজ ও মেইনটেইন করছেন **[@itshimelz](https://github.com/itshimelz)**

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [বাংলা](README.bn.md)

</div>

---

## 📸 স্ক্রিনশটসমূহ
<div align="center">

| 🎵 লিরিক্স | 🖼️ অনলাইন ওয়ালপেপার |
|:---:|:---:|
| ![Screenshot 1](screenshots/1.png) | ![Screenshot 2](screenshots/2.png) |
| 🪟 ডেক্সটপ উইজেট | 🔧 হাইপারল্যান্ড কনফিগ |
| ![Screenshot 5](screenshots/5.png) | ![Screenshot 6](screenshots/6.png) |
| ⚙️ কনফিগারযোগ্য বার | ✨ এবং আরও অনেক কিছু |
| ![Screenshot 3](screenshots/3.png) | ![Screenshot 4](screenshots/4.png) |

</div>

---

## ⚡ ইনস্টলেশন প্রক্রিয়া

> [!NOTE]
> এই ফর্কটি তার নিজস্ব কনফিগারেশন ফোল্ডার আলাদাভাবে ম্যানেজ করে—তাই এটি আপনার বিদ্যমান কোনো সেটআপ মুছে ফেলবে না বা পরিবর্তন করবে না। তবে এটি সঠিকভাবে চালানোর জন্য সিস্টেমে [illogical-impulse](https://github.com/end-4/dots-hyprland) ইনস্টল থাকা ও রানিং থাকা প্রয়োজন।

```bash
cd ~/.config/quickshell/
git clone https://github.com/itshimelz/end4-itshimelz.git
killall qs 2>/dev/null; qs -c end4-itshimelz > /dev/null 2>&1 & disown
```

### 🔧 ডিফল্ট শেল হিসেবে সেট করা (ঐচ্ছিক)

আপনি যদি এটি পছন্দ করেন এবং ডিফল্ট `ii`-এর বদলে এটি সবসময় লোড করতে চান, তবে আপনার এই ফাইলটি এডিট করুন:

```bash
~/.config/hypr/hyprland/variables.lua
```

এবং নিচের লাইনটি পরিবর্তন করুন:

```lua
hl.env("qsConfig", "ii")
```

থেকে পরিবর্তন করে এটি দিন:

```lua
hl.env("qsConfig", "end4-itshimelz")
```

> [!TIP]
> সেভ করার পর পরিবর্তনটি দেখতে Hyprland রিস্টার্ট দিন অথবা টার্মিনালে `hyprctl reload` কমান্ডটি চালান।

---

### ⚙️ গুরুত্বপূর্ণ কি-বাইন্ডিং (Shortcuts)

- **সেটিংস প্যানেল**: `Super + I`
- **চিটশিট / শর্টকাট লিস্ট**: `Super + /`
- **ডান পাশের সাইডবার**: `Super + N`
- **বাম পাশের সাইডবার**: `Super + A`
- **মিডিয়া কন্ট্রোলস**: `Super + M`

---

## 🙏 আপস্ট্রিম ও কৃতজ্ঞতা স্বীকার

এই প্রজেক্টটি **[@pctrade](https://github.com/pctrade)**-এর **[end4-pC](https://github.com/pctrade/end4-pC)** প্রজেক্ট থেকে ফর্ক করা, যা মূলত **[@end-4](https://github.com/end-4)**-এর অসাধারণ প্রজেক্ট **[illogical-impulse](https://github.com/end-4/dots-hyprland)**-এর ওপর ভিত্তি করে তৈরি।

মূল ডেভেলপার ও কন্ট্রিবিউটরদের প্রতি অশেষ ধন্যবাদ, যাদের কাজের ওপর ভিত্তি করে এই প্রজেক্ট সম্ভব হয়েছে:

- **[@end-4](https://github.com/end-4)** — **[illogical-impulse / dots-hyprland](https://github.com/end-4/dots-hyprland)**-এর মূল স্রষ্টা। লিনাক্স হাইপারল্যান্ড ডটফাইলস ইকোসিস্টেমে তার অবদান অনবদ্য 🫡
- **[@pctrade](https://github.com/pctrade)** — **[end4-pC](https://github.com/pctrade/end4-pC)**-এর স্রষ্টা (আমাদের সরাসরি আপস্ট্রিম ফর্ক) 🛠️
- **[@itshimelz](https://github.com/itshimelz)** — ফর্ক কাস্টমাইজেশন, পাইপওয়্যার অডিও পোর্ট সুইচার, ইন্সট্যান্ট MPRIS প্লেয়ার সিঙ্ক, রেসপনসিভ শর্টকাট চিটশিট এবং মেইনটেন্যান্স 🚀
- **[@gh0stzk](https://github.com/gh0stzk)** — ওয়েদার উইজেটের জন্য ওয়েদার এপিআই (Weather API) ইন্টিগ্রেশন 🙌
- **[@StarS2112](https://github.com/StarS2112)** — শোকেস ও কমিউনিটি সাপোর্ট 🙌

---

<div align="center">

**[@end-4](https://github.com/end-4)**-এর **[illogical-impulse](https://github.com/end-4/dots-hyprland)** এবং **[@pctrade](https://github.com/pctrade)**-এর **[end4-pC](https://github.com/pctrade/end4-pC)**-এর ওপর ভিত্তি করে তৈরি • ভালোবাসার সাথে কাস্টমাইজ করেছেন **[@itshimelz](https://github.com/itshimelz)**

</div>
