local _ENV, troopsHelper
local troopsMatrixUtil = include("troopsMatrixUtil")
local MatrixType = troopsMatrixUtil.MatrixType
local EffectType = troopsMatrixUtil.EffectType
local SoldierBatchType = troopsMatrixUtil.SoldierBatchType
local GROU_TROOP_ID = 1000
_ENV = nil
;(nil)[worldMapDefine.soldierType_GongjianBing] = worldMapDefine.pointsType_RANGE
;(nil)[worldMapDefine.soldierType_ZhanChe] = worldMapDefine.pointsType_BARRACKS
;(nil)[worldMapDefine.soldierType_JingYing] = worldMapDefine.pointsType_RANGE
;(nil)[worldMapDefine.soldierType_LegendLord] = worldMapDefine.pointsType_HIDE
;(nil)[worldMapDefine.soldierType_HeroBack] = worldMapDefine.pointsType_HIDE
;(nil)[worldMapDefine.soldierType_PantherGongjian] = worldMapDefine.pointsType_RANGE
;(nil)[worldMapDefine.soldierType_Lion] = worldMapDefine.pointsType_HIDE
;(nil)[worldMapDefine.soldierType_StarNuBing] = worldMapDefine.pointsType_RANGE
;(nil)[worldMapDefine.soldierType_StarCheBing] = worldMapDefine.pointsType_BARRACKS
;(nil)[worldMapDefine.soldierType_Sniper] = worldMapDefine.pointsType_RANGE
;(nil)[worldMapDefine.soldierType_Trick] = worldMapDefine.pointsType_RANGE
;(nil)[worldMapDefine.soldierType_SniperBing] = worldMapDefine.pointsType_RANGE
;(nil)[worldMapDefine.soldierType_starship] = worldMapDefine.pointsType_RANGE
local _ENV, _ENV, (nil)[worldMapDefine.soldierType_starshipx], soldierPointsCfg = worldMapDefine.pointsType_RANGE, worldMapDefine.soldierType_starshipx, worldMapDefine.pointsType_RANGE, nil
worldMapDefine.pointsType_RANGE.index = 1
worldMapDefine.pointsType_RANGE.subType = 28
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_None
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Normal
_ENV, worldMapDefine.soldierType_starshipx[1], worldMapDefine.pointsType_RANGE.batchType = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_Normal
worldMapDefine.pointsType_RANGE.index = 2
_ENV, worldMapDefine.pointsType_RANGE.subType = SoldierBatchType.SoldierBatchType_Normal, 41
worldMapDefine.pointsType_RANGE.keyCfg, SoldierBatchType.SoldierBatchType_Normal.key = SoldierBatchType.SoldierBatchType_Normal, "troop_medal"
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Medal
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Normal
_ENV, worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal
SoldierBatchType.SoldierBatchType_Normal.scale = 1.5
_ENV, worldMapDefine.soldierType_starshipx[2], worldMapDefine.pointsType_RANGE.preCfg, SoldierBatchType.SoldierBatchType_Normal.offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10)
worldMapDefine.pointsType_RANGE.index = 3
_ENV, worldMapDefine.pointsType_RANGE.subType = SoldierBatchType.SoldierBatchType_Normal, 42
worldMapDefine.pointsType_RANGE.keyCfg, SoldierBatchType.SoldierBatchType_Normal.key = SoldierBatchType.SoldierBatchType_Normal, "troop_king"
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_King
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Normal
_ENV, worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal
SoldierBatchType.SoldierBatchType_Normal.scale = 1.5
_ENV, worldMapDefine.soldierType_starshipx[3], worldMapDefine.pointsType_RANGE.preCfg, SoldierBatchType.SoldierBatchType_Normal.offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10)
worldMapDefine.pointsType_RANGE.index = 4
_ENV, worldMapDefine.pointsType_RANGE.subType = SoldierBatchType.SoldierBatchType_Normal, 134
SoldierBatchType.SoldierBatchType_Normal.key = "troop_hegemon"
worldMapDefine.pointsType_RANGE.keyCfg, SoldierBatchType.SoldierBatchType_Normal.scale = SoldierBatchType.SoldierBatchType_Normal, 1.2
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Hegemon
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Normal
_ENV, _ENV, worldMapDefine.pointsType_RANGE.batchType = cc.p(-80, -10), SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal
cc.p(-80, -10).autocull = false
_ENV, cc.p(-80, -10).plist = -80, "et_bawangxj_01.plist"
;(-80).x = -60
cc.p(-80, -10).pos, (-80).y = -80, 0
cc.p(-80, -10).scale = 1.36
_ENV, SoldierBatchType.SoldierBatchType_Normal[1], cc.p(-80, -10).rotate = cc.p(-80, -10), cc.p(-80, -10), -180
cc.p(-80, -10).autocull = false
cc.p(-80, -10).plist = "et_bawangxj_02.plist"
cc.p(-80, -10).rotate = -180
_ENV, worldMapDefine.pointsType_RANGE.effect_fg, SoldierBatchType.SoldierBatchType_Normal[2], cc.p(-80, -10).scale = SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10), 1.36
SoldierBatchType.SoldierBatchType_Normal.scale = 1.5
_ENV, worldMapDefine.soldierType_starshipx[4], worldMapDefine.pointsType_RANGE.preCfg, SoldierBatchType.SoldierBatchType_Normal.offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10)
worldMapDefine.pointsType_RANGE.index = 5
worldMapDefine.pointsType_RANGE.subType = 107
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Skin
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Normal
_ENV, _ENV, worldMapDefine.pointsType_RANGE.batchType = cc.p(-80, -10), SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal
cc.p(-80, -10).autocull = false
cc.p(-80, -10).plist = "et_xjqrj_02.plist"
cc.p(-80, -10).rotate = -180.87
_ENV, cc.p(-80, -10).scale = -80, 1.1
;(-80).x = -7.2
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_fg, SoldierBatchType.SoldierBatchType_Normal[1], cc.p(-80, -10).pos, (-80).y = cc.p(-80, -10), SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10), -80, 4.19
cc.p(-80, -10).autocull = false
cc.p(-80, -10).plist = "et_xjqrj_01.plist"
cc.p(-80, -10).rotate = -180
_ENV, cc.p(-80, -10).scale = -80, 0.9846
;(-80).x = -45.22
_ENV, worldMapDefine.pointsType_RANGE.effect_fg_blend, SoldierBatchType.SoldierBatchType_Normal[1], cc.p(-80, -10).pos, (-80).y = SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10), -80, 11.93
SoldierBatchType.SoldierBatchType_Normal.scale = 1.5
_ENV, worldMapDefine.soldierType_starshipx[5], worldMapDefine.pointsType_RANGE.preCfg, SoldierBatchType.SoldierBatchType_Normal.offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10)
worldMapDefine.pointsType_RANGE.index = 6
worldMapDefine.pointsType_RANGE.subType = 108
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Skin
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Normal
_ENV, _ENV, worldMapDefine.pointsType_RANGE.batchType = cc.p(-80, -10), SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal
cc.p(-80, -10).autocull = false
cc.p(-80, -10).plist = "et_xjxh_01.plist"
cc.p(-80, -10).rotate = -180
_ENV, cc.p(-80, -10).scale = -80, 1.2
;(-80).x = -6.31
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_fg, SoldierBatchType.SoldierBatchType_Normal[1], cc.p(-80, -10).pos, (-80).y = cc.p(-80, -10), SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10), -80, 9.45
cc.p(-80, -10).autocull = false
cc.p(-80, -10).plist = "et_xjxh_02.plist"
cc.p(-80, -10).rotate = -174.73
_ENV, cc.p(-80, -10).scale = -80, 1.91
;(-80).x = -48.83
_ENV, worldMapDefine.pointsType_RANGE.effect_fg_blend, SoldierBatchType.SoldierBatchType_Normal[1], cc.p(-80, -10).pos, (-80).y = SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10), -80, 4.38
SoldierBatchType.SoldierBatchType_Normal.scale = 1.5
_ENV, worldMapDefine.soldierType_starshipx[6], worldMapDefine.pointsType_RANGE.preCfg, SoldierBatchType.SoldierBatchType_Normal.offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10)
worldMapDefine.pointsType_RANGE.index = 7
worldMapDefine.pointsType_RANGE.subType = 109
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Skin
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Normal
_ENV, _ENV, worldMapDefine.pointsType_RANGE.batchType = cc.p(-80, -10), SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal
cc.p(-80, -10).autocull = false
cc.p(-80, -10).plist = "et_xjcd_02.plist"
_ENV, cc.p(-80, -10).rotate = -80, -180.52
;(-80).x = 1.24
_ENV, cc.p(-80, -10).scale, (-80).y = -80, -80, 1.21
;(-80).x = -75.26
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_fg, SoldierBatchType.SoldierBatchType_Normal[1], cc.p(-80, -10).pos, (-80).y = cc.p(-80, -10), SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10), -80, -5.0
cc.p(-80, -10).autocull = false
cc.p(-80, -10).plist = "et_xjcd_03.plist"
_ENV, cc.p(-80, -10).rotate = -80, -183.85
;(-80).x = 1.0134
_ENV, cc.p(-80, -10).scale, (-80).y = -80, -80, 0.984
;(-80).x = -50.15
_ENV, worldMapDefine.pointsType_RANGE.effect_fg_blend, SoldierBatchType.SoldierBatchType_Normal[1], cc.p(-80, -10).pos, (-80).y = SoldierBatchType.SoldierBatchType_Normal, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10), -80, -1.66
SoldierBatchType.SoldierBatchType_Normal.scale = 1.5
_ENV, worldMapDefine.soldierType_starshipx[7], worldMapDefine.pointsType_RANGE.preCfg, SoldierBatchType.SoldierBatchType_Normal.offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_Normal, cc.p(-80, -10)
worldMapDefine.pointsType_RANGE.index = 8
worldMapDefine.pointsType_RANGE.subType = 175
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_None
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Snow
worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_Normal
_ENV, worldMapDefine.pointsType_RANGE.troopsMatrixFile = SoldierBatchType.SoldierBatchType_Normal, "troopsMatrixSnow"
worldMapDefine.pointsType_RANGE.armyModel, SoldierBatchType.SoldierBatchType_Normal["14"] = SoldierBatchType.SoldierBatchType_Normal, 4
_ENV, worldMapDefine.soldierType_starshipx[8], worldMapDefine.pointsType_RANGE.needMoving = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, true
worldMapDefine.pointsType_RANGE.index = 9
worldMapDefine.pointsType_RANGE.subType = 83
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_None
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Jack
worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_Normal
_ENV, worldMapDefine.pointsType_RANGE.troopsMatrixFile = SoldierBatchType.SoldierBatchType_Normal, "troopsMatrixJack"
worldMapDefine.pointsType_RANGE.armyModel, SoldierBatchType.SoldierBatchType_Normal["13"] = SoldierBatchType.SoldierBatchType_Normal, 4
worldMapDefine.pointsType_RANGE.isRandom = true
worldMapDefine.pointsType_RANGE.soldierScale = 0.8
_ENV, worldMapDefine.soldierType_starshipx[9], worldMapDefine.pointsType_RANGE.needMoving = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, true
worldMapDefine.pointsType_RANGE.index = 10
worldMapDefine.pointsType_RANGE.subType = IsArClient and 140 or 144
worldMapDefine.pointsType_RANGE.troopsMatrixFile = "troopsMatrixPanther"
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Panther
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Panther
worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_Panther
_ENV, worldMapDefine.pointsType_RANGE.batchFile = SoldierBatchType.SoldierBatchType_Panther, "FrameAnimation/worldMapSoliderPanther"
SoldierBatchType.SoldierBatchType_Panther["10"] = 1
SoldierBatchType.SoldierBatchType_Panther["11"] = 1
worldMapDefine.pointsType_RANGE.armyModel, SoldierBatchType.SoldierBatchType_Panther["12"] = SoldierBatchType.SoldierBatchType_Panther, 2
worldMapDefine.pointsType_RANGE.soldierScale = 0.825
_ENV, _ENV, worldMapDefine.pointsType_RANGE.isRandom = cc.p(-80, -10), SoldierBatchType.SoldierBatchType_Panther, true
cc.p(-80, -10).autocull = false
_ENV, cc.p(-80, -10).plist = -80, "et_heibaoxingjun_05.plist"
;(-80).x = -170
cc.p(-80, -10).pos, (-80).y = -80, 0
cc.p(-80, -10).scale = 1.07
_ENV, SoldierBatchType.SoldierBatchType_Panther[1], cc.p(-80, -10).rotate = cc.p(-80, -10), cc.p(-80, -10), -100
cc.p(-80, -10).autocull = false
_ENV, cc.p(-80, -10).plist = -80, "et_heibaoxingjun_06.plist"
;(-80).x = -50
cc.p(-80, -10).pos, (-80).y = -80, 0
cc.p(-80, -10).scale = 1.0
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_fg, SoldierBatchType.SoldierBatchType_Panther[2], cc.p(-80, -10).rotate = cc.p(-80, -10), SoldierBatchType.SoldierBatchType_Panther, SoldierBatchType.SoldierBatchType_Panther, cc.p(-80, -10), -175
cc.p(-80, -10).autocull = false
_ENV, cc.p(-80, -10).plist = -80, "et_heibaoxingjun_03.plist"
;(-80).x = -150
cc.p(-80, -10).pos, (-80).y = -80, 0
cc.p(-80, -10).scale = 0.8
_ENV, SoldierBatchType.SoldierBatchType_Panther[1], cc.p(-80, -10).rotate = cc.p(-80, -10), cc.p(-80, -10), -175
cc.p(-80, -10).autocull = false
_ENV, cc.p(-80, -10).plist = -80, "et_heibaoxingjun_01.plist"
;(-80).x = -150
cc.p(-80, -10).pos, (-80).y = -80, 0
cc.p(-80, -10).scale = 1.67
_ENV, SoldierBatchType.SoldierBatchType_Panther[2], cc.p(-80, -10).rotate = cc.p(-80, -10), cc.p(-80, -10), -165
cc.p(-80, -10).autocull = false
_ENV, cc.p(-80, -10).plist = -80, "et_heibaoxingjun_02.plist"
;(-80).x = -150
cc.p(-80, -10).pos, (-80).y = -80, 0
cc.p(-80, -10).scale = 0.75
_ENV, worldMapDefine.pointsType_RANGE.effect_bg, SoldierBatchType.SoldierBatchType_Panther[3], cc.p(-80, -10).rotate = SoldierBatchType.SoldierBatchType_Panther, SoldierBatchType.SoldierBatchType_Panther, cc.p(-80, -10), -175
SoldierBatchType.SoldierBatchType_Panther.scale = 1.2
_ENV, worldMapDefine.soldierType_starshipx[10], worldMapDefine.pointsType_RANGE.preCfg, SoldierBatchType.SoldierBatchType_Panther.offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_Panther, cc.p(-230, -60)
worldMapDefine.pointsType_RANGE.index = 11
worldMapDefine.pointsType_RANGE.subType = IsArClient and 263 or 266
worldMapDefine.pointsType_RANGE.troopsMatrixFile = "troopsMatrixTiger"
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Tiger
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Tiger
worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_WhiteTiger
_ENV, worldMapDefine.pointsType_RANGE.batchFile = SoldierBatchType.SoldierBatchType_WhiteTiger, "FrameAnimation/worldMapSoliderWhiteTiger"
SoldierBatchType.SoldierBatchType_WhiteTiger["21"] = 1
SoldierBatchType.SoldierBatchType_WhiteTiger["22"] = 1
worldMapDefine.pointsType_RANGE.armyModel, SoldierBatchType.SoldierBatchType_WhiteTiger["23"] = SoldierBatchType.SoldierBatchType_WhiteTiger, 1
worldMapDefine.pointsType_RANGE.soldierScale = 0.75
_ENV, _ENV, worldMapDefine.pointsType_RANGE.isRandom = cc.p(-230, -60), SoldierBatchType.SoldierBatchType_WhiteTiger, true
cc.p(-230, -60).fileType = "frames"
cc.p(-230, -60).autocull = false
cc.p(-230, -60).imgName = "dh_bhxjtx1_%.2d.png"
cc.p(-230, -60).beginFrame = 0
cc.p(-230, -60).endFrame = 16
cc.p(-230, -60).imagNum = 17
cc.p(-230, -60).fNum = 17
_ENV, cc.p(-230, -60).rotate = -230, 187
;(-230).x = -60
_ENV, cc.p(-230, -60).pos, (-230).y = -230, -230, 0
;(-230).x = 1.08
cc.p(-230, -60).scale, (-230).y = -230, 0.942
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_fg_blend, SoldierBatchType.SoldierBatchType_WhiteTiger[1], cc.p(-230, -60).blendOne = cc.p(-230, -60), SoldierBatchType.SoldierBatchType_WhiteTiger, SoldierBatchType.SoldierBatchType_WhiteTiger, cc.p(-230, -60), true
cc.p(-230, -60).fileType = "frames"
cc.p(-230, -60).autocull = false
cc.p(-230, -60).imgName = "dh_bhxjtx2_%.2d.png"
cc.p(-230, -60).beginFrame = 0
cc.p(-230, -60).endFrame = 16
cc.p(-230, -60).imagNum = 17
cc.p(-230, -60).fNum = 17
_ENV, cc.p(-230, -60).rotate = -230, 187
;(-230).x = -50
_ENV, cc.p(-230, -60).pos, (-230).y = -230, -230, 0
;(-230).x = 1.08
_ENV, worldMapDefine.pointsType_RANGE.effect_bg, SoldierBatchType.SoldierBatchType_WhiteTiger[1], cc.p(-230, -60).scale, (-230).y = SoldierBatchType.SoldierBatchType_WhiteTiger, SoldierBatchType.SoldierBatchType_WhiteTiger, cc.p(-230, -60), -230, 1.032
SoldierBatchType.SoldierBatchType_WhiteTiger.scale = 1.2
_ENV, worldMapDefine.soldierType_starshipx[11], worldMapDefine.pointsType_RANGE.preCfg, SoldierBatchType.SoldierBatchType_WhiteTiger.offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_WhiteTiger, cc.p(-180, -70)
worldMapDefine.pointsType_RANGE.index = 12
worldMapDefine.pointsType_RANGE.subType = 201
worldMapDefine.pointsType_RANGE.troopsMatrixFile = "troopsMatrixLion"
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Lion
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Lion
worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_Lion
_ENV, worldMapDefine.pointsType_RANGE.batchFile = SoldierBatchType.SoldierBatchType_Lion, "FrameAnimation/worldMapSoliderLion"
SoldierBatchType.SoldierBatchType_Lion["15"] = 4
worldMapDefine.pointsType_RANGE.armyModel, SoldierBatchType.SoldierBatchType_Lion["16"] = SoldierBatchType.SoldierBatchType_Lion, 1
worldMapDefine.pointsType_RANGE.soldierScale = 0.8
_ENV, _ENV, worldMapDefine.pointsType_RANGE.isRandom = cc.p(-180, -70), SoldierBatchType.SoldierBatchType_Lion, true
cc.p(-180, -70).autocull = false
_ENV, cc.p(-180, -70).plist = -180, "et_Par_szxj_002.plist"
;(-180).x = -22.330000000000013
cc.p(-180, -70).pos, (-180).y = -180, -6.68
cc.p(-180, -70).scale = 2
_ENV, SoldierBatchType.SoldierBatchType_Lion[1], cc.p(-180, -70).rotate = cc.p(-180, -70), cc.p(-180, -70), -90
cc.p(-180, -70).autocull = false
_ENV, cc.p(-180, -70).plist = -180, "et_Par_szxj_004.plist"
;(-180).x = -153.67000000000002
cc.p(-180, -70).pos, (-180).y = -180, -2.1
cc.p(-180, -70).scale = 1
_ENV, SoldierBatchType.SoldierBatchType_Lion[2], cc.p(-180, -70).rotate = cc.p(-180, -70), cc.p(-180, -70), -90
cc.p(-180, -70).autocull = false
_ENV, cc.p(-180, -70).plist = -180, "et_Par_szxj_002.plist"
;(-180).x = -304.18
_ENV, cc.p(-180, -70).pos, (-180).y = -180, -180, -4.05
;(-180).x = 1.9
cc.p(-180, -70).scale, (-180).y = -180, 2
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_fg, SoldierBatchType.SoldierBatchType_Lion[3], cc.p(-180, -70).rotate = cc.p(-180, -70), SoldierBatchType.SoldierBatchType_Lion, SoldierBatchType.SoldierBatchType_Lion, cc.p(-180, -70), -90
cc.p(-180, -70).autocull = false
_ENV, cc.p(-180, -70).plist = -180, "et_Par_szxj_001.plist"
;(-180).x = -158.06
_ENV, cc.p(-180, -70).pos, (-180).y = -180, -180, -23.71
;(-180).x = 2.26
cc.p(-180, -70).scale, (-180).y = -180, 2.5
_ENV, SoldierBatchType.SoldierBatchType_Lion[1], cc.p(-180, -70).rotate = cc.p(-180, -70), cc.p(-180, -70), -90
cc.p(-180, -70).autocull = false
_ENV, cc.p(-180, -70).plist = -180, "et_Par_szxj_003.plist"
;(-180).x = -24.830000000000013
_ENV, cc.p(-180, -70).pos, (-180).y = -180, -180, -4.04
;(-180).x = 2
cc.p(-180, -70).scale, (-180).y = -180, 2.5
_ENV, SoldierBatchType.SoldierBatchType_Lion[2], cc.p(-180, -70).rotate = cc.p(-180, -70), cc.p(-180, -70), -90
cc.p(-180, -70).autocull = false
_ENV, cc.p(-180, -70).plist = -180, "et_Par_szxj_003.plist"
;(-180).x = -258.71
_ENV, cc.p(-180, -70).pos, (-180).y = -180, -180, -18.03
;(-180).x = 2.8
cc.p(-180, -70).scale, (-180).y = -180, 3.2
_ENV, SoldierBatchType.SoldierBatchType_Lion[3], cc.p(-180, -70).rotate = cc.p(-180, -70), cc.p(-180, -70), -90
cc.p(-180, -70).autocull = false
_ENV, cc.p(-180, -70).plist = -180, "et_Par_szxj_002.plist"
;(-180).x = -140.82
cc.p(-180, -70).pos, (-180).y = -180, -13.96
cc.p(-180, -70).scale = 1.5
_ENV, worldMapDefine.pointsType_RANGE.effect_bg, SoldierBatchType.SoldierBatchType_Lion[4], cc.p(-180, -70).rotate = SoldierBatchType.SoldierBatchType_Lion, SoldierBatchType.SoldierBatchType_Lion, cc.p(-180, -70), -90
SoldierBatchType.SoldierBatchType_Lion.scale = 1.2
_ENV, worldMapDefine.soldierType_starshipx[12], worldMapDefine.pointsType_RANGE.preCfg, SoldierBatchType.SoldierBatchType_Lion.offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_Lion, cc.p(-230, -90)
worldMapDefine.pointsType_RANGE.index = 13
worldMapDefine.pointsType_RANGE.subType = 268
worldMapDefine.pointsType_RANGE.troopsMatrixFile = "troopsMatrixCharge"
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Charge
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Charge
worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_Dictator
_ENV, worldMapDefine.pointsType_RANGE.batchFile = SoldierBatchType.SoldierBatchType_Dictator, "FrameAnimation/worldMapSoliderDictator"
SoldierBatchType.SoldierBatchType_Dictator["24"] = 1
worldMapDefine.pointsType_RANGE.armyModel, SoldierBatchType.SoldierBatchType_Dictator["25"] = SoldierBatchType.SoldierBatchType_Dictator, 1
worldMapDefine.pointsType_RANGE.soldierScale = 0.65
_ENV, _ENV, worldMapDefine.pointsType_RANGE.isRandom = cc.p(-230, -90), SoldierBatchType.SoldierBatchType_Dictator, true
cc.p(-230, -90).fileType = "frames"
cc.p(-230, -90).autocull = false
cc.p(-230, -90).imgName = "dh_xjrw_alpha_%.2d.png"
cc.p(-230, -90).imagNum = 15
cc.p(-230, -90).fNum = 15
_ENV, cc.p(-230, -90).rotate = -230, 220
;(-230).x = -50
cc.p(-230, -90).pos, (-230).y = -230, 0
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_fg, SoldierBatchType.SoldierBatchType_Dictator[1], cc.p(-230, -90).scale = cc.p(-230, -90), SoldierBatchType.SoldierBatchType_Dictator, SoldierBatchType.SoldierBatchType_Dictator, cc.p(-230, -90), 1
cc.p(-230, -90).fileType = "frames"
cc.p(-230, -90).autocull = false
cc.p(-230, -90).imgName = "dh_xjrw_add_%.2d.png"
cc.p(-230, -90).imagNum = 15
cc.p(-230, -90).fNum = 15
_ENV, cc.p(-230, -90).rotate = -230, 220
;(-230).x = -50
cc.p(-230, -90).pos, (-230).y = -230, 0
cc.p(-230, -90).scale = 1
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_fg_blend, SoldierBatchType.SoldierBatchType_Dictator[1], cc.p(-230, -90).blendOne = cc.p(-230, -90), SoldierBatchType.SoldierBatchType_Dictator, SoldierBatchType.SoldierBatchType_Dictator, cc.p(-230, -90), true
cc.p(-230, -90).fileType = "frames"
cc.p(-230, -90).autocull = false
cc.p(-230, -90).imgName = "dh_xjxb_alpha_%.2d.png"
cc.p(-230, -90).imagNum = 15
cc.p(-230, -90).fNum = 15
_ENV, cc.p(-230, -90).rotate = -230, 220
;(-230).x = -90
cc.p(-230, -90).pos, (-230).y = -230, 0
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_bg, SoldierBatchType.SoldierBatchType_Dictator[1], cc.p(-230, -90).scale = cc.p(-230, -90), SoldierBatchType.SoldierBatchType_Dictator, SoldierBatchType.SoldierBatchType_Dictator, cc.p(-230, -90), 1
cc.p(-230, -90).fileType = "frames"
cc.p(-230, -90).autocull = false
cc.p(-230, -90).imgName = "dh_xjxb_add_%.2d.png"
cc.p(-230, -90).imagNum = 15
cc.p(-230, -90).fNum = 15
_ENV, cc.p(-230, -90).rotate = -230, 220
;(-230).x = -90
cc.p(-230, -90).pos, (-230).y = -230, 0
cc.p(-230, -90).scale = 1
_ENV, worldMapDefine.pointsType_RANGE.effect_bg_blend, SoldierBatchType.SoldierBatchType_Dictator[1], cc.p(-230, -90).blendOne = SoldierBatchType.SoldierBatchType_Dictator, SoldierBatchType.SoldierBatchType_Dictator, cc.p(-230, -90), true
SoldierBatchType.SoldierBatchType_Dictator.scale = 1.5
_ENV, worldMapDefine.soldierType_starshipx[13], worldMapDefine.pointsType_RANGE.preCfg, SoldierBatchType.SoldierBatchType_Dictator.offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_Dictator, cc.p(-50, -20)
worldMapDefine.pointsType_RANGE.index = 14
worldMapDefine.pointsType_RANGE.subType = 344
worldMapDefine.pointsType_RANGE.troopsMatrixFile = "troopsMatrixSniper"
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Sniper
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Sniper
worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_Sniper
_ENV, worldMapDefine.pointsType_RANGE.batchFile = SoldierBatchType.SoldierBatchType_Sniper, "FrameAnimation/worldMapSoliderjuji"
SoldierBatchType.SoldierBatchType_Sniper["26"] = 2
worldMapDefine.pointsType_RANGE.armyModel, SoldierBatchType.SoldierBatchType_Sniper["32"] = SoldierBatchType.SoldierBatchType_Sniper, 2
worldMapDefine.pointsType_RANGE.soldierScale = 1.0
_ENV, _ENV, worldMapDefine.pointsType_RANGE.isRandom = cc.p(-50, -20), SoldierBatchType.SoldierBatchType_Sniper, true
cc.p(-50, -20).fileType = "frames"
cc.p(-50, -20).autocull = false
cc.p(-50, -20).imgName = "dh_jjs_xj_xia_%.2d.png"
cc.p(-50, -20).imagNum = 24
cc.p(-50, -20).fNum = 24
cc.p(-50, -20).scale = 2
_ENV, cc.p(-50, -20).rotate = -50, 180
;(-50).x = -174
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_bg, SoldierBatchType.SoldierBatchType_Sniper[1], cc.p(-50, -20).pos, (-50).y = cc.p(-50, -20), SoldierBatchType.SoldierBatchType_Sniper, SoldierBatchType.SoldierBatchType_Sniper, cc.p(-50, -20), -50, -23
cc.p(-50, -20).fileType = "frames"
cc.p(-50, -20).autocull = false
cc.p(-50, -20).imgName = "dh_jjs_xj_shang_%.2d.png"
cc.p(-50, -20).imagNum = 24
cc.p(-50, -20).fNum = 24
cc.p(-50, -20).scale = 2
_ENV, cc.p(-50, -20).rotate = -50, 180
;(-50).x = -190
_ENV, worldMapDefine.pointsType_RANGE.effect_fg, SoldierBatchType.SoldierBatchType_Sniper[1], cc.p(-50, -20).pos, (-50).y = SoldierBatchType.SoldierBatchType_Sniper, SoldierBatchType.SoldierBatchType_Sniper, cc.p(-50, -20), -50, 0
SoldierBatchType.SoldierBatchType_Sniper.scale = 1.35
_ENV, worldMapDefine.soldierType_starshipx[14], worldMapDefine.pointsType_RANGE.preCfg, SoldierBatchType.SoldierBatchType_Sniper.offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, SoldierBatchType.SoldierBatchType_Sniper, cc.p(-140, -40)
worldMapDefine.pointsType_RANGE.index = 15
worldMapDefine.pointsType_RANGE.subType = 370
worldMapDefine.pointsType_RANGE.troopsMatrixFile = "troopsMatrixTrick"
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Trick
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Trick
worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_Trick
_ENV, worldMapDefine.pointsType_RANGE.batchFile = "FrameAnimation/worldMapSoliderTrickHunter", "FrameAnimation/worldMapSoliderTrickHunter"
;("FrameAnimation/worldMapSoliderTrickHunter")["27"] = 2
;("FrameAnimation/worldMapSoliderTrickHunter")["28"] = 1
worldMapDefine.pointsType_RANGE.armyModel, ("FrameAnimation/worldMapSoliderTrickHunter")["29"] = "FrameAnimation/worldMapSoliderTrickHunter", 1
worldMapDefine.pointsType_RANGE.soldierScale = 1.0
_ENV, _ENV, worldMapDefine.pointsType_RANGE.isRandom = "29", "FrameAnimation/worldMapSoliderTrickHunter", true
;("29").fileType = "frames"
;("29").autocull = false
;("29").imgName = "dh_xjtx_zx_ZC_S_%.2d.png"
;("29").imagNum = 24
;("29").fNum = 15
_ENV, ("29").rotate = 210, 210
;(210).x = -140
;("29").pos, (210).y = 210, 0
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_fg, ("FrameAnimation/worldMapSoliderTrickHunter")[1], ("29").scale = "29", "FrameAnimation/worldMapSoliderTrickHunter", "FrameAnimation/worldMapSoliderTrickHunter", "29", 2
;("29").fileType = "frames"
;("29").autocull = false
;("29").imgName = "dh_xjtx_zx_ADD_S_%.2d.png"
;("29").imagNum = 24
;("29").fNum = 15
_ENV, ("29").rotate = 210, 210
;(210).x = -140
;("29").pos, (210).y = 210, 0
;("29").scale = 2
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_fg_blend, ("FrameAnimation/worldMapSoliderTrickHunter")[1], ("29").blendOne = "29", "FrameAnimation/worldMapSoliderTrickHunter", "FrameAnimation/worldMapSoliderTrickHunter", "29", true
;("29").fileType = "frames"
;("29").autocull = false
;("29").imgName = "dh_xjtx_zx_ZC_x_%.2d.png"
;("29").imagNum = 24
;("29").fNum = 15
_ENV, ("29").rotate = 200, 200
;(200).x = -140
;("29").pos, (200).y = 200, -20
_ENV, _ENV, worldMapDefine.pointsType_RANGE.effect_bg, ("FrameAnimation/worldMapSoliderTrickHunter")[1], ("29").scale = "29", "FrameAnimation/worldMapSoliderTrickHunter", "FrameAnimation/worldMapSoliderTrickHunter", "29", 2
;("29").fileType = "frames"
;("29").autocull = false
;("29").imgName = "dh_xjtx_zx_ADD_x_%.2d.png"
;("29").imagNum = 24
;("29").fNum = 15
_ENV, ("29").rotate = 200, 200
;(200).x = -140
;("29").pos, (200).y = 200, -20
;("29").scale = 2
_ENV, worldMapDefine.pointsType_RANGE.effect_bg_blend, ("FrameAnimation/worldMapSoliderTrickHunter")[1], ("29").blendOne = "FrameAnimation/worldMapSoliderTrickHunter", "FrameAnimation/worldMapSoliderTrickHunter", "29", true
;("FrameAnimation/worldMapSoliderTrickHunter").scale = 1.35
_ENV, worldMapDefine.soldierType_starshipx[15], worldMapDefine.pointsType_RANGE.preCfg, ("FrameAnimation/worldMapSoliderTrickHunter").offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, "FrameAnimation/worldMapSoliderTrickHunter", cc.p(-140, -40)
worldMapDefine.pointsType_RANGE.index = 16
worldMapDefine.pointsType_RANGE.subType = 387
worldMapDefine.pointsType_RANGE.troopsMatrixFile = "troopsMatrixWorldcup"
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Worldcup
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Worldcup
worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_Worldcup
_ENV, worldMapDefine.pointsType_RANGE.batchFile = "FrameAnimation/worldMapSoliderWorldcup", "FrameAnimation/worldMapSoliderWorldcup"
;("FrameAnimation/worldMapSoliderWorldcup")["30"] = 1
worldMapDefine.pointsType_RANGE.armyModel, ("FrameAnimation/worldMapSoliderWorldcup")["31"] = "FrameAnimation/worldMapSoliderWorldcup", 1
worldMapDefine.pointsType_RANGE.soldierScale = 1.0
_ENV, _ENV, worldMapDefine.pointsType_RANGE.isRandom = "31", "FrameAnimation/worldMapSoliderWorldcup", true
;("31").fileType = "frames"
;("31").autocull = false
;("31").imgName = "dh_sjbxj_ZC_%.2d.png"
;("31").imagNum = 24
;("31").fNum = 15
;("31").scale = 2
_ENV, ("31").rotate = "dh_sjbxj_ZC_%.2d.png", 180
;("dh_sjbxj_ZC_%.2d.png").x = -180
_ENV, worldMapDefine.pointsType_RANGE.effect_bg, ("FrameAnimation/worldMapSoliderWorldcup")[1], ("31").pos, ("dh_sjbxj_ZC_%.2d.png").y = "FrameAnimation/worldMapSoliderWorldcup", "FrameAnimation/worldMapSoliderWorldcup", "31", "dh_sjbxj_ZC_%.2d.png", 0
;("FrameAnimation/worldMapSoliderWorldcup").scale = 1.5
_ENV, worldMapDefine.soldierType_starshipx[16], worldMapDefine.pointsType_RANGE.preCfg, ("FrameAnimation/worldMapSoliderWorldcup").offset = worldMapDefine.pointsType_RANGE, worldMapDefine.pointsType_RANGE, "FrameAnimation/worldMapSoliderWorldcup", cc.p(-120, -40)
worldMapDefine.pointsType_RANGE.index = 17
worldMapDefine.pointsType_RANGE.subType = 415
worldMapDefine.pointsType_RANGE.troopsMatrixFile = "troopsMatrixIcedragon"
worldMapDefine.pointsType_RANGE.effectType = EffectType.EffectType_Icedragon
worldMapDefine.pointsType_RANGE.matrixType = MatrixType.MatrixType_Icedragon
worldMapDefine.pointsType_RANGE.batchType = SoldierBatchType.SoldierBatchType_Icedragon
_ENV, worldMapDefine.pointsType_RANGE.batchFile = "FrameAnimation/worldMapSoliderIcedragon", "FrameAnimation/worldMapSoliderIcedragon"
;("FrameAnimation/worldMapSoliderIcedragon")["33"] = 1
worldMapDefine.pointsType_RANGE.armyModel, ("FrameAnimation/worldMapSoliderIcedragon")["34"] = "FrameAnimation/worldMapSoliderIcedragon", 1
worldMapDefine.pointsType_RANGE.soldierScale = 1.0
_ENV, _ENV, worldMapDefine.pointsType_RANGE.isRandom = "34", "FrameAnimation/worldMapSoliderIcedragon", true
;("34").fileType = "frames"
;("34").autocull = false
;("34").imgName = "dh_blxjtx_%.2d.png"
;("34").imagNum = 24
_ENV, ("34").fNum = "dh_blxjtx_%.2d.png", 15
;("dh_blxjtx_%.2d.png").x = 2
;("34").scale, ("dh_blxjtx_%.2d.png").y = "dh_blxjtx_%.2d.png", -2
_ENV, ("34").rotate = "dh_blxjtx_%.2d.png", 180
;("dh_blxjtx_%.2d.png").x = -250
_ENV, worldMapDefine.pointsType_RANGE.effect_bg, ("FrameAnimation/worldMapSoliderIcedragon")[1], ("34").pos, ("dh_blxjtx_%.2d.png").y = "FrameAnimation/worldMapSoliderIcedragon", "FrameAnimation/worldMapSoliderIcedragon", "34", "dh_blxjtx_%.2d.png", 50
;("FrameAnimation/worldMapSoliderIcedragon").scale = 1.0
worldMapDefine.soldierType_starshipx[17], worldMapDefine.pointsType_RANGE.preCfg, ("FrameAnimation/worldMapSoliderIcedragon").offset = worldMapDefine.pointsType_RANGE, "FrameAnimation/worldMapSoliderIcedragon", cc.p(-120, -30)
_ENV = "FrameAnimation/worldMapSoliderIcedragon"
;("FrameAnimation/worldMapSoliderIcedragon").index = 18
;("FrameAnimation/worldMapSoliderIcedragon").subType = 434
;("FrameAnimation/worldMapSoliderIcedragon").troopsMatrixFile = "troopsMatrixLaoji"
;("FrameAnimation/worldMapSoliderIcedragon").effectType = EffectType.EffectType_Laoji
;("FrameAnimation/worldMapSoliderIcedragon").matrixType = MatrixType.MatrixType_Laoji
;("FrameAnimation/worldMapSoliderIcedragon").batchType = SoldierBatchType.SoldierBatchType_Laoji
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").batchFile = "FrameAnimation/worldMapSoliderLaoji", "FrameAnimation/worldMapSoliderLaoji"
;("FrameAnimation/worldMapSoliderLaoji")["35"] = 1
;("FrameAnimation/worldMapSoliderIcedragon").armyModel, ("FrameAnimation/worldMapSoliderLaoji")["36"] = "FrameAnimation/worldMapSoliderLaoji", 1
;("FrameAnimation/worldMapSoliderIcedragon").soldierScale = 1.0
_ENV, _ENV, ("FrameAnimation/worldMapSoliderIcedragon").isRandom = "36", "FrameAnimation/worldMapSoliderLaoji", true
;("36").fileType = "frames"
;("36").autocull = false
;("36").imgName = "dh_ljxj_%.2d.png"
;("36").imagNum = 24
_ENV, ("36").fNum = "dh_ljxj_%.2d.png", 15
;("dh_ljxj_%.2d.png").x = 2
;("36").scale, ("dh_ljxj_%.2d.png").y = "dh_ljxj_%.2d.png", -2
_ENV, ("36").rotate = "dh_ljxj_%.2d.png", 180
;("dh_ljxj_%.2d.png").x = -250
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").effect_bg, ("FrameAnimation/worldMapSoliderLaoji")[1], ("36").pos, ("dh_ljxj_%.2d.png").y = "FrameAnimation/worldMapSoliderLaoji", "FrameAnimation/worldMapSoliderLaoji", "36", "dh_ljxj_%.2d.png", 0
;("FrameAnimation/worldMapSoliderLaoji").scale = 1.2
worldMapDefine.soldierType_starshipx[18], ("FrameAnimation/worldMapSoliderIcedragon").preCfg, ("FrameAnimation/worldMapSoliderLaoji").offset = "FrameAnimation/worldMapSoliderIcedragon", "FrameAnimation/worldMapSoliderLaoji", cc.p(-180, -60)
_ENV = "FrameAnimation/worldMapSoliderIcedragon"
;("FrameAnimation/worldMapSoliderIcedragon").index = 19
;("FrameAnimation/worldMapSoliderIcedragon").subType = 438
;("FrameAnimation/worldMapSoliderIcedragon").troopsMatrixFile = "troopsMatrixHTJC"
;("FrameAnimation/worldMapSoliderIcedragon").effectType = EffectType.EffectType_HTJC
;("FrameAnimation/worldMapSoliderIcedragon").matrixType = MatrixType.MatrixType_HTJC
;("FrameAnimation/worldMapSoliderIcedragon").batchType = SoldierBatchType.SoldierBatchType_HTJC
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").batchFile = "FrameAnimation/worldMapSoliderHTJC", "FrameAnimation/worldMapSoliderHTJC"
;("FrameAnimation/worldMapSoliderHTJC")["37"] = 1
;("FrameAnimation/worldMapSoliderIcedragon").armyModel, ("FrameAnimation/worldMapSoliderHTJC")["38"] = "FrameAnimation/worldMapSoliderHTJC", 1
;("FrameAnimation/worldMapSoliderIcedragon").soldierScale = 1.0
_ENV, _ENV, ("FrameAnimation/worldMapSoliderIcedragon").isRandom = "38", "FrameAnimation/worldMapSoliderHTJC", true
;("38").fileType = "frames"
;("38").autocull = false
;("38").imgName = "dh_htjcxj_w_%.2d.png"
;("38").imagNum = 24
_ENV, ("38").fNum = "dh_htjcxj_w_%.2d.png", 15
;("dh_htjcxj_w_%.2d.png").x = 2
;("38").scale, ("dh_htjcxj_w_%.2d.png").y = "dh_htjcxj_w_%.2d.png", -2
_ENV, ("38").rotate = "dh_htjcxj_w_%.2d.png", 180
;("dh_htjcxj_w_%.2d.png").x = -370
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").effect_bg, ("FrameAnimation/worldMapSoliderHTJC")[1], ("38").pos, ("dh_htjcxj_w_%.2d.png").y = "FrameAnimation/worldMapSoliderHTJC", "FrameAnimation/worldMapSoliderHTJC", "38", "dh_htjcxj_w_%.2d.png", 0
;("FrameAnimation/worldMapSoliderHTJC").scale = 1.0
worldMapDefine.soldierType_starshipx[19], ("FrameAnimation/worldMapSoliderIcedragon").preCfg, ("FrameAnimation/worldMapSoliderHTJC").offset = "FrameAnimation/worldMapSoliderIcedragon", "FrameAnimation/worldMapSoliderHTJC", cc.p(-180, -60)
_ENV = "FrameAnimation/worldMapSoliderIcedragon"
;("FrameAnimation/worldMapSoliderIcedragon").index = 20
;("FrameAnimation/worldMapSoliderIcedragon").subType = 443
;("FrameAnimation/worldMapSoliderIcedragon").troopsMatrixFile = "troopsMatrixHYFL"
;("FrameAnimation/worldMapSoliderIcedragon").effectType = EffectType.EffectType_HYFL
;("FrameAnimation/worldMapSoliderIcedragon").matrixType = MatrixType.MatrixType_HYFL
;("FrameAnimation/worldMapSoliderIcedragon").batchType = SoldierBatchType.SoldierBatchType_HYFL
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").batchFile = "FrameAnimation/worldMapSoldierHYFL", "FrameAnimation/worldMapSoldierHYFL"
;("FrameAnimation/worldMapSoldierHYFL")["40"] = 1
;("FrameAnimation/worldMapSoliderIcedragon").armyModel, ("FrameAnimation/worldMapSoldierHYFL")["41"] = "FrameAnimation/worldMapSoldierHYFL", 1
;("FrameAnimation/worldMapSoliderIcedragon").soldierScale = 1.2
_ENV, _ENV, ("FrameAnimation/worldMapSoliderIcedragon").isRandom = "41", "FrameAnimation/worldMapSoldierHYFL", true
;("41").fileType = "frames"
;("41").autocull = false
;("41").imgName = "dh_huolongrydm_%.2d.png"
;("41").imagNum = 24
_ENV, ("41").fNum = "dh_huolongrydm_%.2d.png", 15
;("dh_huolongrydm_%.2d.png").x = 2
;("41").scale, ("dh_huolongrydm_%.2d.png").y = "dh_huolongrydm_%.2d.png", -2
_ENV, ("41").rotate = "dh_huolongrydm_%.2d.png", 180
;("dh_huolongrydm_%.2d.png").x = -220
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").effect_bg, ("FrameAnimation/worldMapSoldierHYFL")[1], ("41").pos, ("dh_huolongrydm_%.2d.png").y = "FrameAnimation/worldMapSoldierHYFL", "FrameAnimation/worldMapSoldierHYFL", "41", "dh_huolongrydm_%.2d.png", 0
;("FrameAnimation/worldMapSoldierHYFL").scale = 1.2
worldMapDefine.soldierType_starshipx[20], ("FrameAnimation/worldMapSoliderIcedragon").preCfg, ("FrameAnimation/worldMapSoldierHYFL").offset = "FrameAnimation/worldMapSoliderIcedragon", "FrameAnimation/worldMapSoldierHYFL", cc.p(-180, -60)
_ENV = "FrameAnimation/worldMapSoliderIcedragon"
;("FrameAnimation/worldMapSoliderIcedragon").index = 21
;("FrameAnimation/worldMapSoliderIcedragon").subType = 448
;("FrameAnimation/worldMapSoliderIcedragon").troopsMatrixFile = "troopsMatrixPJSS"
;("FrameAnimation/worldMapSoliderIcedragon").effectType = EffectType.EffectType_PJSS
;("FrameAnimation/worldMapSoliderIcedragon").matrixType = MatrixType.MatrixType_PJSS
;("FrameAnimation/worldMapSoliderIcedragon").batchType = SoldierBatchType.SoldierBatchType_PJSS
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").batchFile = "FrameAnimation/worldMapSoliderPJSS", "FrameAnimation/worldMapSoliderPJSS"
;("FrameAnimation/worldMapSoliderPJSS")["42"] = 1
;("FrameAnimation/worldMapSoliderIcedragon").armyModel, ("FrameAnimation/worldMapSoliderPJSS")["43"] = "FrameAnimation/worldMapSoliderPJSS", 1
;("FrameAnimation/worldMapSoliderIcedragon").soldierScale = 1.0
_ENV, _ENV, ("FrameAnimation/worldMapSoliderIcedragon").isRandom = "43", "FrameAnimation/worldMapSoliderPJSS", true
;("43").fileType = "frames"
;("43").autocull = false
;("43").imgName = "dh_pjsjl_yd_%.2d.png"
;("43").imagNum = 24
_ENV, ("43").fNum = "dh_pjsjl_yd_%.2d.png", 15
;("dh_pjsjl_yd_%.2d.png").x = 1.7
;("43").scale, ("dh_pjsjl_yd_%.2d.png").y = "dh_pjsjl_yd_%.2d.png", -1.7
_ENV, ("43").rotate = "dh_pjsjl_yd_%.2d.png", 180
;("dh_pjsjl_yd_%.2d.png").x = -300
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").effect_bg, ("FrameAnimation/worldMapSoliderPJSS")[1], ("43").pos, ("dh_pjsjl_yd_%.2d.png").y = "FrameAnimation/worldMapSoliderPJSS", "FrameAnimation/worldMapSoliderPJSS", "43", "dh_pjsjl_yd_%.2d.png", 50
;("FrameAnimation/worldMapSoliderPJSS").scale = 1.0
worldMapDefine.soldierType_starshipx[21], ("FrameAnimation/worldMapSoliderIcedragon").preCfg, ("FrameAnimation/worldMapSoliderPJSS").offset = "FrameAnimation/worldMapSoliderIcedragon", "FrameAnimation/worldMapSoliderPJSS", cc.p(-180, -60)
_ENV = "FrameAnimation/worldMapSoliderIcedragon"
;("FrameAnimation/worldMapSoliderIcedragon").index = 22
;("FrameAnimation/worldMapSoliderIcedragon").subType = 454
;("FrameAnimation/worldMapSoliderIcedragon").troopsMatrixFile = "troopsMatrixBlueDragon"
;("FrameAnimation/worldMapSoliderIcedragon").effectType = EffectType.EffectType_BlueDragon
;("FrameAnimation/worldMapSoliderIcedragon").matrixType = MatrixType.MatrixType_BlueDragon
;("FrameAnimation/worldMapSoliderIcedragon").batchType = SoldierBatchType.SoldierBatchType_BlueDragon
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").batchFile = "FrameAnimation/worldMapSoldierBlueDragon", "FrameAnimation/worldMapSoldierBlueDragon"
;("FrameAnimation/worldMapSoldierBlueDragon")["44"] = 1
;("FrameAnimation/worldMapSoliderIcedragon").armyModel, ("FrameAnimation/worldMapSoldierBlueDragon")["45"] = "FrameAnimation/worldMapSoldierBlueDragon", 1
;("FrameAnimation/worldMapSoliderIcedragon").soldierScale = 1.0
_ENV, _ENV, ("FrameAnimation/worldMapSoliderIcedragon").isRandom = "45", "FrameAnimation/worldMapSoldierBlueDragon", true
;("45").fileType = "frames"
;("45").autocull = false
;("45").imgName = "dh_lansexml_xj_%.2d.png"
;("45").imagNum = 24
_ENV, ("45").fNum = "dh_lansexml_xj_%.2d.png", 15
;("dh_lansexml_xj_%.2d.png").x = 1.7
;("45").scale, ("dh_lansexml_xj_%.2d.png").y = "dh_lansexml_xj_%.2d.png", -1.7
_ENV, ("45").rotate = "dh_lansexml_xj_%.2d.png", 180
;("dh_lansexml_xj_%.2d.png").x = -300
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").effect_bg, ("FrameAnimation/worldMapSoldierBlueDragon")[1], ("45").pos, ("dh_lansexml_xj_%.2d.png").y = "FrameAnimation/worldMapSoldierBlueDragon", "FrameAnimation/worldMapSoldierBlueDragon", "45", "dh_lansexml_xj_%.2d.png", 50
;("FrameAnimation/worldMapSoldierBlueDragon").scale = 1.0
worldMapDefine.soldierType_starshipx[22], ("FrameAnimation/worldMapSoliderIcedragon").preCfg, ("FrameAnimation/worldMapSoldierBlueDragon").offset = "FrameAnimation/worldMapSoliderIcedragon", "FrameAnimation/worldMapSoldierBlueDragon", cc.p(-180, -60)
_ENV = "FrameAnimation/worldMapSoliderIcedragon"
;("FrameAnimation/worldMapSoliderIcedragon").index = 23
;("FrameAnimation/worldMapSoliderIcedragon").subType = 459
;("FrameAnimation/worldMapSoliderIcedragon").troopsMatrixFile = "troopsMatrixStarShip"
;("FrameAnimation/worldMapSoliderIcedragon").effectType = EffectType.EffectType_StarShip
;("FrameAnimation/worldMapSoliderIcedragon").matrixType = MatrixType.MatrixType_StarShip
;("FrameAnimation/worldMapSoliderIcedragon").batchType = SoldierBatchType.SoldierBatchType_StarShip
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").batchFile = "FrameAnimation/worldMapSoldierStarShip", "FrameAnimation/worldMapSoldierStarShip"
;("FrameAnimation/worldMapSoldierStarShip")["46"] = 2
;("FrameAnimation/worldMapSoliderIcedragon").armyModel, ("FrameAnimation/worldMapSoldierStarShip")["47"] = "FrameAnimation/worldMapSoldierStarShip", 2
;("FrameAnimation/worldMapSoliderIcedragon").soldierScale = 1
_ENV, _ENV, ("FrameAnimation/worldMapSoliderIcedragon").isRandom = "47", "FrameAnimation/worldMapSoldierStarShip", true
;("47").fileType = "frames"
;("47").autocull = false
;("47").imgName = "dh_qmxxj_%.2d.png"
;("47").imagNum = 24
_ENV, ("47").fNum = "dh_qmxxj_%.2d.png", 15
;("dh_qmxxj_%.2d.png").x = 2
;("47").scale, ("dh_qmxxj_%.2d.png").y = "dh_qmxxj_%.2d.png", -2
_ENV, ("47").rotate = "dh_qmxxj_%.2d.png", 180
;("dh_qmxxj_%.2d.png").x = -300
_ENV, ("FrameAnimation/worldMapSoliderIcedragon").effect_bg, ("FrameAnimation/worldMapSoldierStarShip")[1], ("47").pos, ("dh_qmxxj_%.2d.png").y = "FrameAnimation/worldMapSoldierStarShip", "FrameAnimation/worldMapSoldierStarShip", "47", "dh_qmxxj_%.2d.png", 30
;("FrameAnimation/worldMapSoldierStarShip").scale = 1.0
_ENV, worldMapDefine.soldierType_starshipx[23], ("FrameAnimation/worldMapSoliderIcedragon").preCfg, ("FrameAnimation/worldMapSoldierStarShip").offset = 23, "FrameAnimation/worldMapSoliderIcedragon", "FrameAnimation/worldMapSoldierStarShip", cc.p(-180, -60)
;(23).index = 24
;(23).subType = 464
;(23).troopsMatrixFile = "troopsMatrixKZP"
;(23).effectType = EffectType.EffectType_KZP
;(23).matrixType = MatrixType.MatrixType_KZP
;(23).batchType = SoldierBatchType.SoldierBatchType_KZP
_ENV, (23).batchFile = "FrameAnimation/worldMapSoliderKZP", "FrameAnimation/worldMapSoliderKZP"
;("FrameAnimation/worldMapSoliderKZP")["48"] = 3
;(23).armyModel, ("FrameAnimation/worldMapSoliderKZP")["49"] = "FrameAnimation/worldMapSoliderKZP", 3
;(23).soldierScale = 1.0
;(23).isRandom = true
_ENV, _ENV, (23).needMoving = "49", "FrameAnimation/worldMapSoliderKZP", true
;("49").fileType = "frames"
;("49").autocull = false
;("49").imgName = "dh_zydpxjtx_%.2d.png"
;("49").imagNum = 15
_ENV, ("49").fNum = "dh_zydpxjtx_%.2d.png", 15
;("dh_zydpxjtx_%.2d.png").x = 1.5
;("49").scale, ("dh_zydpxjtx_%.2d.png").y = "dh_zydpxjtx_%.2d.png", -1.5
_ENV, ("49").rotate = "dh_zydpxjtx_%.2d.png", 180
;("dh_zydpxjtx_%.2d.png").x = -300
_ENV, (23).effect_bg, ("FrameAnimation/worldMapSoliderKZP")[1], ("49").pos, ("dh_zydpxjtx_%.2d.png").y = "FrameAnimation/worldMapSoliderKZP", "FrameAnimation/worldMapSoliderKZP", "49", "dh_zydpxjtx_%.2d.png", 30
;("FrameAnimation/worldMapSoliderKZP").scale = 0.9
worldMapDefine.soldierType_starshipx[24], (23).preCfg, ("FrameAnimation/worldMapSoliderKZP").offset = 23, "FrameAnimation/worldMapSoliderKZP", cc.p(-180, -60)
_ENV = "FrameAnimation/worldMapSoliderKZP"
;("FrameAnimation/worldMapSoliderKZP").index = 25
;("FrameAnimation/worldMapSoliderKZP").subType = 472
;("FrameAnimation/worldMapSoliderKZP").troopsMatrixFile = "troopsMatrixFHXJ"
;("FrameAnimation/worldMapSoliderKZP").effectType = EffectType.EffectType_FHXJ
;("FrameAnimation/worldMapSoliderKZP").matrixType = MatrixType.MatrixType_FHXJ
;("FrameAnimation/worldMapSoliderKZP").batchFile = "FrameAnimation/worldMapSoliderFHXJ"
_ENV, ("FrameAnimation/worldMapSoliderKZP").batchType = SoldierBatchType.SoldierBatchType_FHXJ, SoldierBatchType.SoldierBatchType_FHXJ
SoldierBatchType.SoldierBatchType_FHXJ["50"] = 1
;("FrameAnimation/worldMapSoliderKZP").armyModel, SoldierBatchType.SoldierBatchType_FHXJ["51"] = SoldierBatchType.SoldierBatchType_FHXJ, 1
;("FrameAnimation/worldMapSoliderKZP").soldierScale = 1.11
_ENV, _ENV, ("FrameAnimation/worldMapSoliderKZP").isRandom = "51", 1.11, true
;("51").fileType = "frames"
;("51").autocull = false
;("51").imgName = "dh_fhxj_yd_w_%.2d.png"
;("51").imagNum = 24
_ENV, ("51").fNum = "dh_fhxj_yd_w_%.2d.png", 15
;("dh_fhxj_yd_w_%.2d.png").x = 2
;("51").scale, ("dh_fhxj_yd_w_%.2d.png").y = "dh_fhxj_yd_w_%.2d.png", -2
_ENV, ("51").rotate = "dh_fhxj_yd_w_%.2d.png", 180
;("dh_fhxj_yd_w_%.2d.png").x = -300
_ENV, ("FrameAnimation/worldMapSoliderKZP").effect_bg, (1.11)[1], ("51").pos, ("dh_fhxj_yd_w_%.2d.png").y = 1.11, 1.11, "51", "dh_fhxj_yd_w_%.2d.png", 100
;(1.11).scale = 1.0
worldMapDefine.soldierType_starshipx[25], ("FrameAnimation/worldMapSoliderKZP").preCfg, (1.11).offset = "FrameAnimation/worldMapSoliderKZP", 1.11, cc.p(-180, -60)
_ENV = "FrameAnimation/worldMapSoliderKZP"
;("FrameAnimation/worldMapSoliderKZP").index = 26
;("FrameAnimation/worldMapSoliderKZP").subType = 480
;("FrameAnimation/worldMapSoliderKZP").troopsMatrixFile = "troopsMatrixBubble"
;("FrameAnimation/worldMapSoliderKZP").effectType = EffectType.EffectType_Bubble
;("FrameAnimation/worldMapSoliderKZP").matrixType = MatrixType.MatrixType_Bubble
;("FrameAnimation/worldMapSoliderKZP").batchFile = "FrameAnimation/worldMapSoldierBubble"
_ENV, ("FrameAnimation/worldMapSoliderKZP").batchType = SoldierBatchType.SoldierBatchType_Bubble, SoldierBatchType.SoldierBatchType_Bubble
;("FrameAnimation/worldMapSoliderKZP").armyModel, SoldierBatchType.SoldierBatchType_Bubble["54"] = SoldierBatchType.SoldierBatchType_Bubble, 1
_ENV, _ENV, ("FrameAnimation/worldMapSoliderKZP").soldierScale = "54", SoldierBatchType.SoldierBatchType_Bubble, 1
;("54").fileType = "frames"
;("54").autocull = false
;("54").imgName = "paopaojiangjun_yd_fx_%.2d.png"
;("54").beginFrame = 0
;("54").endFrame = 11
;("54").imagNum = 12
_ENV, ("54").fNum = "paopaojiangjun_yd_fx_%.2d.png", 15
;("paopaojiangjun_yd_fx_%.2d.png").x = 2
;("54").scale, ("paopaojiangjun_yd_fx_%.2d.png").y = "paopaojiangjun_yd_fx_%.2d.png", -2
_ENV, ("54").rotate = "paopaojiangjun_yd_fx_%.2d.png", 180
;("paopaojiangjun_yd_fx_%.2d.png").x = -300
_ENV, ("FrameAnimation/worldMapSoliderKZP").effect_bg, SoldierBatchType.SoldierBatchType_Bubble[1], ("54").pos, ("paopaojiangjun_yd_fx_%.2d.png").y = SoldierBatchType.SoldierBatchType_Bubble, SoldierBatchType.SoldierBatchType_Bubble, "54", "paopaojiangjun_yd_fx_%.2d.png", 0
SoldierBatchType.SoldierBatchType_Bubble.scale = 1.0
SoldierBatchType.SoldierBatchType_Bubble.offset = cc.p(-180, -60)
worldMapDefine.soldierType_starshipx[26], ("FrameAnimation/worldMapSoliderKZP").preCfg, SoldierBatchType.SoldierBatchType_Bubble.preViewOffset = "FrameAnimation/worldMapSoliderKZP", SoldierBatchType.SoldierBatchType_Bubble, cc.p(70, 0)
_ENV = "FrameAnimation/worldMapSoliderKZP"
;("FrameAnimation/worldMapSoliderKZP").index = 27
;("FrameAnimation/worldMapSoliderKZP").subType = 488
;("FrameAnimation/worldMapSoliderKZP").troopsMatrixFile = "troopsMatrixSoulWolf"
;("FrameAnimation/worldMapSoliderKZP").effectType = EffectType.EffectType_SoulWolf
;("FrameAnimation/worldMapSoliderKZP").matrixType = MatrixType.MatrixType_SoulWolf
;("FrameAnimation/worldMapSoliderKZP").batchType = SoldierBatchType.SoldierBatchType_SoulWolf
_ENV, ("FrameAnimation/worldMapSoliderKZP").batchFile = "FrameAnimation/worldMapSoldierSoulWolf", "FrameAnimation/worldMapSoldierSoulWolf"
;("FrameAnimation/worldMapSoldierSoulWolf")["55"] = 1
;("FrameAnimation/worldMapSoliderKZP").armyModel, ("FrameAnimation/worldMapSoldierSoulWolf")["56"] = "FrameAnimation/worldMapSoldierSoulWolf", 1
;("FrameAnimation/worldMapSoliderKZP").soldierScale = 1.0
;("FrameAnimation/worldMapSoliderKZP").isRandom = true
_ENV, ("FrameAnimation/worldMapSoliderKZP").needMoving = "FrameAnimation/worldMapSoldierSoulWolf", true
;("FrameAnimation/worldMapSoldierSoulWolf").scale = 1.0
;("FrameAnimation/worldMapSoldierSoulWolf").offset = cc.p(-130, -40)
_ENV, worldMapDefine.soldierType_starshipx[27], ("FrameAnimation/worldMapSoliderKZP").preCfg, ("FrameAnimation/worldMapSoldierSoulWolf").preViewOffset = 27, "FrameAnimation/worldMapSoliderKZP", "FrameAnimation/worldMapSoldierSoulWolf", cc.p(60, 0)
;(27).index = 28
;(27).subType = 499
;(27).troopsMatrixFile = "troopsMatrixHuaChe"
;(27).effectType = EffectType.EffectType_HuaChe
;(27).matrixType = MatrixType.MatrixType_HuaChe
;(27).batchType = SoldierBatchType.SoldierBatchType_HuaChe
_ENV, (27).batchFile = "FrameAnimation/worldMapSoldierHuaChe", "FrameAnimation/worldMapSoldierHuaChe"
;("FrameAnimation/worldMapSoldierHuaChe")["57"] = 1
;(27).armyModel, ("FrameAnimation/worldMapSoldierHuaChe")["58"] = "FrameAnimation/worldMapSoldierHuaChe", 1
_ENV, _ENV, (27).soldierScale = "58", "FrameAnimation/worldMapSoldierHuaChe", 1.0
;("58").fileType = "frames"
;("58").autocull = false
;("58").imgName = "huache_yd_w_fx_%.2d.png"
;("58").beginFrame = 1
;("58").endFrame = 12
;("58").imagNum = 12
_ENV, ("58").fNum = "huache_yd_w_fx_%.2d.png", 15
;("huache_yd_w_fx_%.2d.png").x = 1
;("58").scale, ("huache_yd_w_fx_%.2d.png").y = "huache_yd_w_fx_%.2d.png", -1
_ENV, ("58").rotate = "huache_yd_w_fx_%.2d.png", 180
;("huache_yd_w_fx_%.2d.png").x = -200
_ENV, (27).effect_bg, ("FrameAnimation/worldMapSoldierHuaChe")[1], ("58").pos, ("huache_yd_w_fx_%.2d.png").y = "FrameAnimation/worldMapSoldierHuaChe", "FrameAnimation/worldMapSoldierHuaChe", "58", "huache_yd_w_fx_%.2d.png", 0
;("FrameAnimation/worldMapSoldierHuaChe").scale = 1.0
worldMapDefine.soldierType_starshipx[28], (27).preCfg, ("FrameAnimation/worldMapSoldierHuaChe").offset = 27, "FrameAnimation/worldMapSoldierHuaChe", cc.p(-130, -40)
_ENV = "FrameAnimation/worldMapSoldierHuaChe"
;("FrameAnimation/worldMapSoldierHuaChe").index = 29
;("FrameAnimation/worldMapSoldierHuaChe").subType = 502
;("FrameAnimation/worldMapSoldierHuaChe").troopsMatrixFile = "troopsMatrixBalloon"
;("FrameAnimation/worldMapSoldierHuaChe").effectType = EffectType.EffectType_Balloon
;("FrameAnimation/worldMapSoldierHuaChe").matrixType = MatrixType.MatrixType_Balloon
;("FrameAnimation/worldMapSoldierHuaChe").batchType = SoldierBatchType.SoldierBatchType_Balloon
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").batchFile = "FrameAnimation/worldMapSoldierBalloon", "FrameAnimation/worldMapSoldierBalloon"
;("FrameAnimation/worldMapSoldierBalloon")["59"] = 1
;("FrameAnimation/worldMapSoldierHuaChe").armyModel, ("FrameAnimation/worldMapSoldierBalloon")["60"] = "FrameAnimation/worldMapSoldierBalloon", 1
;("FrameAnimation/worldMapSoldierHuaChe").soldierScale = 1
;("FrameAnimation/worldMapSoldierHuaChe").isRandom = true
_ENV, _ENV, ("FrameAnimation/worldMapSoldierHuaChe").needMoving = "60", "FrameAnimation/worldMapSoldierBalloon", true
;("60").fileType = "frames"
;("60").autocull = false
;("60").imgName = "zsjdq_yd_fx_%.2d.png"
;("60").beginFrame = 1
;("60").endFrame = 12
;("60").imagNum = 12
_ENV, ("60").fNum = "zsjdq_yd_fx_%.2d.png", 15
;("zsjdq_yd_fx_%.2d.png").x = 1.3
;("60").scale, ("zsjdq_yd_fx_%.2d.png").y = "zsjdq_yd_fx_%.2d.png", 1.3
_ENV, ("60").rotate = "zsjdq_yd_fx_%.2d.png", 180
;("zsjdq_yd_fx_%.2d.png").x = -140
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").effect_bg, ("FrameAnimation/worldMapSoldierBalloon")[1], ("60").pos, ("zsjdq_yd_fx_%.2d.png").y = "FrameAnimation/worldMapSoldierBalloon", "FrameAnimation/worldMapSoldierBalloon", "60", "zsjdq_yd_fx_%.2d.png", -15
;("FrameAnimation/worldMapSoldierBalloon").scale = 1
;("FrameAnimation/worldMapSoldierBalloon").offset = cc.p(-170, -40)
worldMapDefine.soldierType_starshipx[29], ("FrameAnimation/worldMapSoldierHuaChe").preCfg, ("FrameAnimation/worldMapSoldierBalloon").preViewOffset = "FrameAnimation/worldMapSoldierHuaChe", "FrameAnimation/worldMapSoldierBalloon", cc.p(50, 0)
_ENV = "FrameAnimation/worldMapSoldierHuaChe"
;("FrameAnimation/worldMapSoldierHuaChe").index = 30
;("FrameAnimation/worldMapSoldierHuaChe").subType = 510
;("FrameAnimation/worldMapSoldierHuaChe").troopsMatrixFile = "troopsMatrixTrain"
;("FrameAnimation/worldMapSoldierHuaChe").effectType = EffectType.EffectType_Train
;("FrameAnimation/worldMapSoldierHuaChe").matrixType = MatrixType.MatrixType_Train
;("FrameAnimation/worldMapSoldierHuaChe").batchType = SoldierBatchType.SoldierBatchType_Train
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").batchFile = "FrameAnimation/worldMapSoldierTrain", "FrameAnimation/worldMapSoldierTrain"
;("FrameAnimation/worldMapSoldierHuaChe").armyModel, ("FrameAnimation/worldMapSoldierTrain")["61"] = "FrameAnimation/worldMapSoldierTrain", 1
;("FrameAnimation/worldMapSoldierHuaChe").soldierScale = 1.25
;("FrameAnimation/worldMapSoldierHuaChe").isRandom = true
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").needMoving = 1.25, true
;(1.25).scale = 1
;(1.25).offset = cc.p(-170, -40)
worldMapDefine.soldierType_starshipx[30], ("FrameAnimation/worldMapSoldierHuaChe").preCfg, (1.25).preViewOffset = "FrameAnimation/worldMapSoldierHuaChe", 1.25, cc.p(30, 0)
_ENV = "FrameAnimation/worldMapSoldierHuaChe"
;("FrameAnimation/worldMapSoldierHuaChe").index = 31
;("FrameAnimation/worldMapSoldierHuaChe").subType = 530
;("FrameAnimation/worldMapSoldierHuaChe").troopsMatrixFile = "troopsMatrixWhale"
;("FrameAnimation/worldMapSoldierHuaChe").effectType = EffectType.EffectType_Whale
;("FrameAnimation/worldMapSoldierHuaChe").matrixType = MatrixType.MatrixType_Whale
;("FrameAnimation/worldMapSoldierHuaChe").batchType = SoldierBatchType.SoldierBatchType_Whale
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").batchFile = "FrameAnimation/worldMapSoldierWhale", "FrameAnimation/worldMapSoldierWhale"
;("FrameAnimation/worldMapSoldierHuaChe").armyModel, ("FrameAnimation/worldMapSoldierWhale")["62"] = "FrameAnimation/worldMapSoldierWhale", 1
;("FrameAnimation/worldMapSoldierHuaChe").soldierScale = 1.25
;("FrameAnimation/worldMapSoldierHuaChe").isRandom = true
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").needMoving = 1.25, true
;(1.25).scale = 1
;(1.25).offset = cc.p(-170, -40)
worldMapDefine.soldierType_starshipx[31], ("FrameAnimation/worldMapSoldierHuaChe").preCfg, (1.25).preViewOffset = "FrameAnimation/worldMapSoldierHuaChe", 1.25, cc.p(40, 0)
_ENV = "FrameAnimation/worldMapSoldierHuaChe"
;("FrameAnimation/worldMapSoldierHuaChe").index = 32
;("FrameAnimation/worldMapSoldierHuaChe").subType = 539
;("FrameAnimation/worldMapSoldierHuaChe").troopsMatrixFile = "troopsMatrixZyxj"
;("FrameAnimation/worldMapSoldierHuaChe").effectType = EffectType.EffectType_Zyxj
;("FrameAnimation/worldMapSoldierHuaChe").matrixType = MatrixType.MatrixType_Zyxj
;("FrameAnimation/worldMapSoldierHuaChe").batchType = SoldierBatchType.SoldierBatchType_Zyxj
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").batchFile = "FrameAnimation/worldMapSoldierZyxj", "FrameAnimation/worldMapSoldierZyxj"
;("FrameAnimation/worldMapSoldierHuaChe").armyModel, ("FrameAnimation/worldMapSoldierZyxj")["63"] = "FrameAnimation/worldMapSoldierZyxj", 1
;("FrameAnimation/worldMapSoldierHuaChe").soldierScale = 1.15
;("FrameAnimation/worldMapSoldierHuaChe").isRandom = true
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").needMoving = 1.15, true
;(1.15).scale = 1
;(1.15).offset = cc.p(-170, -40)
worldMapDefine.soldierType_starshipx[32], ("FrameAnimation/worldMapSoldierHuaChe").preCfg, (1.15).preViewOffset = "FrameAnimation/worldMapSoldierHuaChe", 1.15, cc.p(20, 0)
_ENV = "FrameAnimation/worldMapSoldierHuaChe"
;("FrameAnimation/worldMapSoldierHuaChe").index = 33
;("FrameAnimation/worldMapSoldierHuaChe").subType = 544
;("FrameAnimation/worldMapSoldierHuaChe").troopsMatrixFile = "troopsMatrix26zyxj"
;("FrameAnimation/worldMapSoldierHuaChe").effectType = EffectType.EffectType_26zyxj
;("FrameAnimation/worldMapSoldierHuaChe").matrixType = MatrixType.MatrixType_26zyxj
;("FrameAnimation/worldMapSoldierHuaChe").batchType = SoldierBatchType.SoldierBatchType_26zyxj
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").batchFile = "FrameAnimation/worldMapSoldier26zyxj", "FrameAnimation/worldMapSoldier26zyxj"
;("FrameAnimation/worldMapSoldierHuaChe").armyModel, ("FrameAnimation/worldMapSoldier26zyxj")["65"] = "FrameAnimation/worldMapSoldier26zyxj", 1
;("FrameAnimation/worldMapSoldierHuaChe").soldierScale = 1.12
;("FrameAnimation/worldMapSoldierHuaChe").isRandom = true
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").needMoving = 1.12, true
;(1.12).scale = 1
;(1.12).offset = cc.p(-70, 0)
worldMapDefine.soldierType_starshipx[33], ("FrameAnimation/worldMapSoldierHuaChe").preCfg, (1.12).preViewOffset = "FrameAnimation/worldMapSoldierHuaChe", 1.12, cc.p(80, 0)
_ENV = "FrameAnimation/worldMapSoldierHuaChe"
;("FrameAnimation/worldMapSoldierHuaChe").index = 34
;("FrameAnimation/worldMapSoldierHuaChe").subType = 553
;("FrameAnimation/worldMapSoldierHuaChe").troopsMatrixFile = "troopsMatrixZnqxj2026"
;("FrameAnimation/worldMapSoldierHuaChe").effectType = EffectType.EffectType_znqxj2026
;("FrameAnimation/worldMapSoldierHuaChe").matrixType = MatrixType.MatrixType_znqxj2026
;("FrameAnimation/worldMapSoldierHuaChe").batchType = SoldierBatchType.SoldierBatchType_znqxj2026
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").batchFile = "FrameAnimation/worldMapSoldierZnqxj2026", "FrameAnimation/worldMapSoldierZnqxj2026"
;("FrameAnimation/worldMapSoldierHuaChe").armyModel, ("FrameAnimation/worldMapSoldierZnqxj2026")["66"] = "FrameAnimation/worldMapSoldierZnqxj2026", 1
;("FrameAnimation/worldMapSoldierHuaChe").soldierScale = 1.12
;("FrameAnimation/worldMapSoldierHuaChe").isRandom = true
_ENV, ("FrameAnimation/worldMapSoldierHuaChe").needMoving = 1.12, true
;(1.12).scale = 1
;(1.12).offset = cc.p(-70, -30)
worldMapDefine.soldierType_starshipx[34], ("FrameAnimation/worldMapSoldierHuaChe").preCfg, (1.12).preViewOffset = "FrameAnimation/worldMapSoldierHuaChe", 1.12, cc.p(80, 0)
local marchEffectCfg = worldMapDefine.soldierType_starshipx
local _ENV, subTypeCfg = 34, 34
for _, v in ipairs(marchEffectCfg) do
	subTypeCfg[v.subType] = v
end
function troopsHelper.getMarchEffect(subType)
	return subTypeCfg[subType]
end
function troopsHelper.getMarchPreCfg(subType)
	local param = troopsHelper.getMarchEffect(subType)
	if not param.preCfg then
		troopsHelper = param.preCfg
	end
	return param.preCfg
end
function troopsHelper.createMarchEffectPreview(subType, particle_node, particle_node_bg)
	local param = troopsHelper.getMarchEffect(subType)
	if not param then
		print("error subType yyy", subType)
		return
	end
	if param.effect_bg then
		local et_node = SoraDCreateEffectNode(param.effect_bg)
		et_node:setName("effectbg")
		et_node:setGroupID(0)
		et_node:setGroupAuto(false)
		et_node:addTo(particle_node_bg)
	end
	if param.effect_bg_blend then
		local et_node = SoraDCreateEffectNode(param.effect_bg_blend)
		et_node:setName("effectbgblend")
		et_node:setGroupID(0)
		et_node:setGroupAuto(false)
		et_node:addTo(particle_node_bg)
	end
	if param.effect_fg then
		local et_node = SoraDCreateEffectNode(param.effect_fg)
		et_node:setName("effectfg")
		et_node:setGroupID(0)
		et_node:setGroupAuto(false)
		et_node:addTo(particle_node)
	end
	if param.effect_fg_blend then
		local et_node = SoraDCreateEffectNode(param.effect_fg_blend)
		et_node:setName("effectfgblend")
		et_node:setGroupID(0)
		et_node:setGroupAuto(false)
		et_node:addTo(particle_node)
	end
end
function troopsHelper.getEffectKeyCfg(effectType)
	for _, v in ipairs(marchEffectCfg) do
		if v.effectType == effectType then
			return v.keyCfg
		end
	end
end
function troopsHelper.isInEffectList(effectType, soliderType)
	for _, v in ipairs(marchEffectCfg) do
		if v.effectType and v.effectType == effectType and not v.keyCfg then
			return v.armyModel and v.armyModel[tostring(soliderType)]
		end
	end
end
function troopsHelper.getSoldierScale(soliderType)
	for k, v in ipairs(marchEffectCfg) do
		if v.armyModel and v.armyModel[tostring(soliderType)] then
			return v.soldierScale
		end
	end
end
function troopsHelper.isSoldierRandom(soliderType)
	for k, v in ipairs(marchEffectCfg) do
		if v.armyModel and v.armyModel[tostring(soliderType)] then
			return v.isRandom
		end
	end
end
function troopsHelper.getMarchGroupCfg(index)
	if not marchEffectCfg[index] then
		local marchEffectCfg, cfg = marchEffectCfg[index], marchEffectCfg[index]
	end
	local marchEffectCfg, groupIDCfg
	local marchEffectCfg, groupIDArray
	local add = 0
	if cfg.effect_bg then
		groupIDCfg.bg = GROU_TROOP_ID + index * 10 + add
		add = add + 1
		table.insert(groupIDArray, groupIDCfg.bg)
	end
	if cfg.effect_bg_blend then
		groupIDCfg.bg_blend = GROU_TROOP_ID + index * 10 + add
		add = add + 1
		table.insert(groupIDArray, groupIDCfg.bg_blend)
	end
	groupIDCfg.sg = GROU_TROOP_ID + index * 10 + add
	add = add + 1
	table.insert(groupIDArray, groupIDCfg.sg)
	if cfg.effect_fg then
		groupIDCfg.fg = GROU_TROOP_ID + index * 10 + add
		add = add + 1
		table.insert(groupIDArray, groupIDCfg.fg)
	end
	if cfg.effect_fg_blend then
		groupIDCfg.fg_blend = GROU_TROOP_ID + index * 10 + add
		add = add + 1
		table.insert(groupIDArray, groupIDCfg.fg_blend)
	end
	return groupIDCfg, groupIDArray
end
function troopsHelper.initMarchGroupNode(handle)
	for k, v in ipairs(marchEffectCfg) do
		local groupIDCfg, groupIDArray = troopsHelper.getMarchGroupCfg(k)
		for _, groupID in ipairs(groupIDArray) do
			handle(groupID)
		end
	end
end
function troopsHelper.newTroopInstance(matrixType, troopInstance)
	if matrixType == MatrixType.MatrixType_Normal then
		return include("troopsMatrixNormal").new(troopInstance)
	elseif matrixType == MatrixType.MatrixType_Empty then
		return require("app.game.worldMap.worldMapTroop.troopsMatrixEmpty").new(troopInstance)
	end
	for _, v in ipairs(marchEffectCfg) do
		if v.matrixType and v.matrixType == matrixType and v.troopsMatrixFile then
			return require("app.game.worldMap.worldMapTroop." .. v.troopsMatrixFile).new(troopInstance)
		end
	end
	return include("troopsMatrixNormal").new(troopInstance)
end
function troopsHelper.createMarchEffect(subType, particle_node)
	local param = troopsHelper.getMarchEffect(subType)
	if not param then
		print("error subType xxx", subType)
		return
	end
	local et_node_bg, et_node_bg_blend, et_node_fg, et_node_fg_blend
	local groupIDCfg = troopsHelper.getMarchGroupCfg(param.index)
	if param.effect_bg then
		et_node_bg = SoraDCreateEffectNode(param.effect_bg, nil, nil, groupIDCfg.bg)
		if particle_node and et_node_bg then
			et_node_bg:addTo(particle_node)
		end
	end
	if param.effect_bg_blend then
		et_node_bg_blend = SoraDCreateEffectNode(param.effect_bg_blend, nil, nil, groupIDCfg.bg_blend)
		if particle_node and et_node_bg_blend then
			et_node_bg_blend:addTo(particle_node)
		end
	end
	if param.effect_fg then
		et_node_fg = SoraDCreateEffectNode(param.effect_fg, nil, nil, groupIDCfg.fg)
		if particle_node and et_node_fg then
			et_node_fg:addTo(particle_node)
		end
	end
	if param.effect_fg_blend then
		et_node_fg_blend = SoraDCreateEffectNode(param.effect_fg_blend, nil, nil, groupIDCfg.fg_blend)
		if particle_node and et_node_fg_blend then
			et_node_fg_blend:addTo(particle_node)
		end
	end
end
function troopsHelper.getSoldierPointsType(soliderType)
	return soldierPointsCfg[soliderType] or worldMapDefine.pointsType_CHARIOT
end
function troopsHelper.getBatchType(soliderType)
	for _, v in ipairs(marchEffectCfg) do
		if v.armyModel and v.armyModel[tostring(soliderType)] then
			return v.batchType
		end
	end
end
function troopsHelper.getSoliderNodeBatch(batchType)
	for k, v in ipairs(marchEffectCfg) do
		if v.batchType and v.batchType == batchType and v.batchFile then
			local soliderNodeBatch = SpriteBatchNodeEx:create(getImageFileNameByPlatform(v.batchFile), 30)
			local groupIDCfg = troopsHelper.getMarchGroupCfg(k)
			soliderNodeBatch:setGroupID(groupIDCfg.sg)
			return soliderNodeBatch
		end
	end
end
return troopsHelper
