local starLampCeremonyRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "starlight_ceremony"
;(nil)[2] = true
starLampCeremonyRead:defineValue("starlight_ceremony", nil)
function starLampCeremonyRead.getRankCfg()
	return starLampCeremonyRead.starlight_ceremony
end
return starLampCeremonyRead
