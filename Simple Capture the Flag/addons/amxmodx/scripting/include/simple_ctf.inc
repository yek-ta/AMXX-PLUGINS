/*
Yek'-ta
*/

#if defined _sctf_included
    #endinput
#endif
#define _sctf_included


#define FLAG_ON_GROUND -1
#define FLAG_ON_BASE 0

/**
 * If is there TE Flagger, Give its number.
 *
 * Exm; if(sctf_who_TEflagger() == PlayerID)
 * Exm; if(sctf_who_TEflagger() == 0) // flag is on base
 * Exm; if(sctf_who_TEflagger() == -1) // nobody carries and, flag is on ground.
 *
 * @return      id.
 */
 native sctf_who_TEflagger()


/**
 * If is there CT Flagger, Give its number.
 *
 * Exm; if(sctf_who_CTflagger() == PlayerID)
 * Exm; if(sctf_who_CTflagger() == FLAG_ON_BASE) // flag is on base
 * Exm; if(sctf_who_CTflagger() == FLAG_ON_GROUND) // nobody carries and, flag is on ground.
 *
 * @return      id.
 */
 native sctf_who_CTflagger()


/**
 * When player is at TEFlagBase, it is true
 *
 * Exm; if(is_user_inTEFlagBase(player))
 *
 * @return      When player is at TEFlagBase, it is true
 */
 native is_user_inTEFlagBase(player)


/**
 * When player is at CTFlagBase, it is true
 *
 * Exm; if(is_user_inCTFlagBase(player))
 *
 * @return      When player is at CTFlagBase, it is true
 */
 native is_user_inCTFlagBase(player)

/**
 * Give TEFlagBase Entity index
 *
 *
 * @return      TEFlagBase index
 */
 native sctf_ent_TEFlagBase()

/**
 * Give CTFlagBase Entity index
 *
 *
 * @return      CTFlagBase index
 */
 native sctf_ent_CTFlagBase()

/**
 * Give TEFlag Entity index
 *
 *
 * @return      TEFlag index
 */
 native sctf_ent_TEFlag()

/**
 * Give CTFlag Entity index
 *
 *
 * @return      CTFlag index
 */
 native sctf_ent_CTFlag()


/**
 * When use it, Flag back to base.
 *
 * Exm; sctf_move_to_flag_back(sctf_ent_TEFlag())
 * Exm; sctf_move_to_flag_back(sctf_ent_CTFlag())
 *
 */
 native sctf_move_to_flag_back(flag)



/**
 * When a player is on CTFlagBase, it works.
 *
 * @param player 		who joins on base
 * @param ent        Base ent
 */
forward sctf_player_entered_CTFlagBase(player, ent)


/**
 * When a player is on TEFlagBase, it works.
 *
 * @param player 		who joins on base
 * @param ent        Base ent
 */
forward sctf_player_entered_TEFlagBase(player, ent)


/**
 * when flag is on ground
 *
 * @param player        who dropped the flag
 * @param ent			Flag ent
 */
forward sctf_flag_dropped(player, ent)


/**
 * When player takes the opponent's flag on ground.
 *
 * @param player        who takes
 * @param ent			Flag ent
 */
forward sctf_flag_is_takenoff(player, ent)


/**
 * When player takes own flag and flag is back to base.
 *
 * @param player        who takes
 * @param ent			Flag ent
 */
forward sctf_flag_backtobase(player, ent)


/**
 * When player scorred.
 *
 * @param player        Who scorred
 * @param ent			Flag ent
 */
forward sctf_flag_scored(player, ent)
