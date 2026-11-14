local _ENV, _ENV, CriwareAdxDef
;(nil).BGM = 0
;(nil).SOUND = 1
CriwareAdxDef.MusicType, (nil).VOICE = nil, 2
CriwareAdxDef.MaxVoices = 32
CriwareAdxDef.MaxSamplingRate = 48000
if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
	_ENV, CriwareAdxDef.AcfPath = UnityEngine.Application.platform, "Music/iPhone/koh.acf"
	UnityEngine.Application.platform[CriwareAdxDef.MusicType.BGM] = "Music/iPhone/BGM/"
	UnityEngine.Application.platform[CriwareAdxDef.MusicType.SOUND] = "Music/iPhone/SFX/"
	CriwareAdxDef.MusicPath, UnityEngine.Application.platform[CriwareAdxDef.MusicType.VOICE] = UnityEngine.Application.platform, "Music/iPhone/VO/"
else
	_ENV, CriwareAdxDef.AcfPath = UnityEngine.Application.platform, "Music/Android/koh.acf"
	UnityEngine.Application.platform[CriwareAdxDef.MusicType.BGM] = "Music/Android/BGM/"
	UnityEngine.Application.platform[CriwareAdxDef.MusicType.SOUND] = "Music/Android/SFX/"
	CriwareAdxDef.MusicPath, UnityEngine.Application.platform[CriwareAdxDef.MusicType.VOICE] = UnityEngine.Application.platform, "Music/Android/VO/"
end
if _G.G_IS_Editor then
	local persistent_path = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android"
	if not _G.CS.System.IO.Directory.Exists(persistent_path) then
		_ENV, CriwareAdxDef.AcfPath = _G.CS.System.IO.Directory.Exists(persistent_path), "Music/koh.acf"
		_G.CS.System.IO.Directory.Exists(persistent_path)[CriwareAdxDef.MusicType.BGM] = "Music/BGM/"
		_G.CS.System.IO.Directory.Exists(persistent_path)[CriwareAdxDef.MusicType.SOUND] = "Music/SFX/"
		CriwareAdxDef.MusicPath, _G.CS.System.IO.Directory.Exists(persistent_path)[CriwareAdxDef.MusicType.VOICE] = _G.CS.System.IO.Directory.Exists(persistent_path), "Music/VO/"
	elseif _G.CS.Sultan.GameSetting.ResourceFactoryType == _G.CS.Sultan.ResourceFactoryEnum.Addressable then
		local CSUserSDKManager = _G.CS.Sultan.Manager.UserSDKManager.GetInstance()
		if CSUserSDKManager:getIsIOSRuntime() then
			_ENV, CriwareAdxDef.AcfPath = CSUserSDKManager:getIsIOSRuntime(), "Music/iPhone/koh.acf"
			CSUserSDKManager:getIsIOSRuntime()[CriwareAdxDef.MusicType.BGM] = "Music/iPhone/BGM/"
			CSUserSDKManager:getIsIOSRuntime()[CriwareAdxDef.MusicType.SOUND] = "Music/iPhone/SFX/"
			CriwareAdxDef.MusicPath, CSUserSDKManager:getIsIOSRuntime()[CriwareAdxDef.MusicType.VOICE] = CSUserSDKManager:getIsIOSRuntime(), "Music/iPhone/VO/"
		end
	end
end
_ENV = persistent_path
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").default = "en/"
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").ar = "ar/"
_ENV, CriwareAdxDef.LanguagePath, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").en = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "en/"
_ENV = CSUserSDKManager:getIsIOSRuntime()
CSUserSDKManager:getIsIOSRuntime().control = "Music_volume"
_UPVALUE2_, CSUserSDKManager:getIsIOSRuntime().default = CriwareAdxDef.MusicType.VOICE, 0.8
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[CriwareAdxDef.MusicType.BGM], CSUserSDKManager:getIsIOSRuntime().range, CriwareAdxDef.MusicType.VOICE[1] = CSUserSDKManager:getIsIOSRuntime(), CriwareAdxDef.MusicType.VOICE, 0
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[CriwareAdxDef.MusicType.BGM], CSUserSDKManager:getIsIOSRuntime().range, CriwareAdxDef.MusicType.VOICE[2] = CSUserSDKManager:getIsIOSRuntime(), CriwareAdxDef.MusicType.VOICE, 1
_ENV = CSUserSDKManager:getIsIOSRuntime()
CSUserSDKManager:getIsIOSRuntime().control = "SFX_volume"
_UPVALUE2_, CSUserSDKManager:getIsIOSRuntime().default = CriwareAdxDef.MusicType.VOICE, 0.8
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[CriwareAdxDef.MusicType.SOUND], CSUserSDKManager:getIsIOSRuntime().range, CriwareAdxDef.MusicType.VOICE[1] = CSUserSDKManager:getIsIOSRuntime(), CriwareAdxDef.MusicType.VOICE, 0
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[CriwareAdxDef.MusicType.SOUND], CSUserSDKManager:getIsIOSRuntime().range, CriwareAdxDef.MusicType.VOICE[2] = CSUserSDKManager:getIsIOSRuntime(), CriwareAdxDef.MusicType.VOICE, 1
_ENV = CSUserSDKManager:getIsIOSRuntime()
CSUserSDKManager:getIsIOSRuntime().control = "VO_volume"
_UPVALUE2_, CSUserSDKManager:getIsIOSRuntime().default = CriwareAdxDef.MusicType.VOICE, 0.8
_ENV, CriwareAdxDef.VolumeInfo, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[CriwareAdxDef.MusicType.VOICE], CSUserSDKManager:getIsIOSRuntime().range, CriwareAdxDef.MusicType.VOICE[1] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", CSUserSDKManager:getIsIOSRuntime(), CriwareAdxDef.MusicType.VOICE, 0
_ENV, CriwareAdxDef.VolumeInfo, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[CriwareAdxDef.MusicType.VOICE], CSUserSDKManager:getIsIOSRuntime().range, CriwareAdxDef.MusicType.VOICE[2] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", CSUserSDKManager:getIsIOSRuntime(), CriwareAdxDef.MusicType.VOICE, 1
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").STOP = 0
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").PREP = 1
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").PLAYING = 2
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").PLAYEND = 3
_ENV, CriwareAdxDef.PlayerStatus, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").ERROR = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", 4
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").Stop = 0
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").DecHdr = 1
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").WaitPrep = 2
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").Prep = 3
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").Ready = 4
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").Playing = 5
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").PlayEnd = 6
;(_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").Error = 7
_UPVALUE1_, CriwareAdxDef.VideoStatus, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android").StopProcessing = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", 8
_UPVALUE19_, CriwareAdxDef.CommonAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[1] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Common"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[1] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "BGM"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[2] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "BGM_Loading"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[3] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "SFX"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[4] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "General_UI"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[5] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Epic_War"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[6] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Hero_Ceremony"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[7] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Bowmen"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[8] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "City"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[9] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Smithy"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[10] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Infantry"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[11] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Hunting"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[12] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Pet"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[13] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "War_Chariot"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[14] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Material_Workshop"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[15] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "AMB"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[16] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Cavalry"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[17] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Pyramid"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[18] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Monster_Palace"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[19] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "World_Map"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[20] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Monster_Battle"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[21] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Activities"
_UPVALUE1_, CriwareAdxDef.BattleAcb, _ENV, CriwareAdxDef.MainAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[22] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "Miracle"
CriwareAdxDef.LanguageAcb, (_G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android")[1] = _G.CS.UnityEngine.Application.dataPath .. "/Res/Music/Android", "VO"
gCriwareAdxDef = CriwareAdxDef
return CriwareAdxDef
