import 'dart:core';
//doll type IDs

class CrewFactions {
  static final int HOMESTUCK_HUMAN_ID = 1;
  static final int HOMESTUCK_TROLL_ID = 2;
  static final int CONSORT_ID = 3;
  static final int DENIZEN_ID = 4;
  static final int DAD_ID = 7;
  static final int QUEEN_ID = 8;
  static final int MOM_ID = 9;
  static final int BRO_ID = 10;
  static final int HOMESTUCK_BABY_ID = 12;
  static final int HOMESTUCK_GRUB_ID = 13;
  static final int HIVESWAP_DOLL_ID = 14;
  static final int HOMESTUCK_SATYR_ID = 15;
  static final int HOMESTUCK_CHERUB_ID = 16;
  static final int SUPERB_SUCK_ID = 17;
  static final int VIRUS_ID = 18;
  static final int DOG_ID = 19;
  static final int TALKSPRITE_ID = 20;
  static final int OPENBOUND_ID = 21;
  static final int BROOM_ID = 22;
  static final int CAT_ID = 23;
  static final int BLOB_MONSTER_ID = 25;
  static final int DOC_ID = 26;
  static final int ANCESTOR_ID = 27;
  static final int FEK_ID = 28;
  static final int SMOL_KID_ID = 37;
  static final int SMOL_TROLL_ID = 38;
  static final int DUCK_ID = 39;
  static final int EASTER_EGG_ID = 41;
  static final int HATCHED_CHICK_ID = 42;
  static final int VESSEL_ID = 44;
  static final int MAGICAL_GIRL_ID = 45;
  static final int HOMESTUCK_SATYR_KITTEN_ID = 46;
  static final int COOKIE_ID = 47;
  static final int MAGICAL_GIRL_TWO_ID = 48;
  static final int HOMESTUCK_LAMIA_TREE_BAB_ID = 85;
  static final int HOMESTUCK_LAMIA_ID = 88;
  static final int PIGEON_ID = 113;
  static final int MONSTER_POCKET_ID = 151;
  static final int MONSTER_GIRL_ID = 427;

  static final List<int> HUMAN_FACTION = [
    HOMESTUCK_HUMAN_ID,
    DAD_ID,
    MOM_ID,
    BRO_ID,
    HOMESTUCK_BABY_ID,
    SMOL_KID_ID
  ];
  static final List<int> TROLL_FACTION = [
    HOMESTUCK_TROLL_ID,
    HOMESTUCK_GRUB_ID,
    ANCESTOR_ID,
    SMOL_TROLL_ID
  ];
  static final List<int> GAME_CONSTRUCT_FACTION = [
    CONSORT_ID,
    DENIZEN_ID,
    QUEEN_ID,
    DOC_ID
  ];
  static final List<int> SATYR_FACTION = [
    HOMESTUCK_SATYR_ID,
    HOMESTUCK_SATYR_KITTEN_ID
  ];
  static final List<int> LAMIA_FACTION = [
    HOMESTUCK_LAMIA_ID,
    HOMESTUCK_LAMIA_TREE_BAB_ID
  ];
  static final List<int> MAGICAL_GIRL_FACTION = [
    MAGICAL_GIRL_ID,
    MAGICAL_GIRL_TWO_ID,
    EASTER_EGG_ID,
    HATCHED_CHICK_ID,
    MONSTER_GIRL_ID
  ];
//the next ones only have one member but i figure handling them the same is good practice
  static final List<int> CHERUB_FACTION = [HOMESTUCK_CHERUB_ID];
  static final List<int> VIRUS_FACTION = [VIRUS_ID];
  static final List<int> DOG_FACTION = [DOG_ID];
  static final List<int> BROOM_FACTION = [BROOM_ID];
  static final List<int> CAT_FACTION = [CAT_ID];
  static final List<int> BLOB_MONSTER_FACTION = [BLOB_MONSTER_ID];
  static final List<int> DUCK_FACTION = [DUCK_ID];
  static final List<int> COOKIE_FACTION = [COOKIE_ID];
  static final List<int> PIGEON_FACTION = [PIGEON_ID];
  static final List<int> MONSTER_POCKET_FACTION = [MONSTER_POCKET_ID];

//ALL FACTIONS
  static final List<List<int>> ALL_FACTIONS = [
    HUMAN_FACTION,
    TROLL_FACTION,
    GAME_CONSTRUCT_FACTION,
    SATYR_FACTION,
    LAMIA_FACTION,
    MAGICAL_GIRL_FACTION,
    CHERUB_FACTION,
    VIRUS_FACTION,
    DOG_FACTION,
    BROOM_FACTION,
    CAT_FACTION,
    BLOB_MONSTER_FACTION,
    DUCK_FACTION,
    COOKIE_FACTION,
    PIGEON_FACTION,
    MONSTER_POCKET_FACTION,
  ];

//ALL DOLLS
  static final List<int> ALL_IDS = [
    HOMESTUCK_HUMAN_ID,
    HOMESTUCK_TROLL_ID,
    CONSORT_ID,
    DENIZEN_ID,
    DAD_ID,
    QUEEN_ID,
    MOM_ID,
    BRO_ID,
    HOMESTUCK_BABY_ID,
    HOMESTUCK_GRUB_ID,
    HIVESWAP_DOLL_ID,
    HOMESTUCK_SATYR_ID,
    HOMESTUCK_CHERUB_ID,
    SUPERB_SUCK_ID,
    VIRUS_ID,
    DOG_ID,
    TALKSPRITE_ID,
    OPENBOUND_ID,
    BROOM_ID,
    CAT_ID,
    BLOB_MONSTER_ID,
    DOC_ID,
    ANCESTOR_ID,
    FEK_ID,
    SMOL_KID_ID,
    SMOL_TROLL_ID,
    DUCK_ID,
    EASTER_EGG_ID,
    HATCHED_CHICK_ID,
    VESSEL_ID,
    MAGICAL_GIRL_ID,
    HOMESTUCK_SATYR_KITTEN_ID,
    COOKIE_ID,
    MAGICAL_GIRL_TWO_ID,
    HOMESTUCK_LAMIA_TREE_BAB_ID,
    HOMESTUCK_LAMIA_ID,
    PIGEON_ID,
    MONSTER_POCKET_ID,
    MONSTER_GIRL_ID
  ];
}
