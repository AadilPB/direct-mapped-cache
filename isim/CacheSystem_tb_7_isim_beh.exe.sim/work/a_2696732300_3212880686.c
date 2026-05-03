/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ddf5b5d */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/student1/a2bholat/coe758/CacheController_1.1/SDRAMController.vhd";
extern char *IEEE_P_1242562249;

char *ieee_p_1242562249_sub_10420449594411817395_1035706684(char *, char *, int , int );
int ieee_p_1242562249_sub_17802405650254020620_1035706684(char *, char *, char *);


static void work_a_2696732300_3212880686_p_0(char *t0)
{
    char t18[16];
    char t45[16];
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    int t9;
    unsigned char t10;
    char *t11;
    int t12;
    int t13;
    char *t14;
    char *t15;
    int t16;
    int t17;
    char *t19;
    int t20;
    int t21;
    char *t22;
    int t23;
    int t24;
    char *t25;
    char *t26;
    int t27;
    int t28;
    unsigned int t29;
    unsigned int t30;
    char *t31;
    int t32;
    int t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    char *t38;
    char *t39;
    char *t40;
    char *t41;
    char *t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;

LAB0:    xsi_set_current_line(44, ng0);
    t2 = (t0 + 992U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 3624);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(46, ng0);
    t4 = (t0 + 2152U);
    t8 = *((char **)t4);
    t9 = *((int *)t8);
    t10 = (t9 == 0);
    if (t10 != 0)
        goto LAB8;

LAB10:
LAB9:    xsi_set_current_line(55, ng0);
    t2 = (t0 + 1512U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB21;

LAB23:
LAB22:    goto LAB3;

LAB5:    t4 = (t0 + 1032U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(47, ng0);
    t4 = (t0 + 8512);
    *((int *)t4) = 0;
    t11 = (t0 + 8516);
    *((int *)t11) = 7;
    t12 = 0;
    t13 = 7;

LAB11:    if (t12 <= t13)
        goto LAB12;

LAB14:    xsi_set_current_line(52, ng0);
    t2 = (t0 + 3768);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    *((int *)t11) = 1;
    xsi_driver_first_trans_fast(t2);
    goto LAB9;

LAB12:    xsi_set_current_line(48, ng0);
    t14 = (t0 + 8520);
    *((int *)t14) = 0;
    t15 = (t0 + 8524);
    *((int *)t15) = 31;
    t16 = 0;
    t17 = 31;

LAB15:    if (t16 <= t17)
        goto LAB16;

LAB18:
LAB13:    t2 = (t0 + 8512);
    t12 = *((int *)t2);
    t4 = (t0 + 8516);
    t13 = *((int *)t4);
    if (t12 == t13)
        goto LAB14;

LAB20:    t9 = (t12 + 1);
    t12 = t9;
    t5 = (t0 + 8512);
    *((int *)t5) = t12;
    goto LAB11;

LAB16:    xsi_set_current_line(49, ng0);
    t19 = (t0 + 8512);
    t20 = *((int *)t19);
    t21 = (t20 * 32);
    t22 = (t0 + 8520);
    t23 = *((int *)t22);
    t24 = (t21 + t23);
    t25 = ieee_p_1242562249_sub_10420449594411817395_1035706684(IEEE_P_1242562249, t18, t24, 8);
    t26 = (t0 + 8512);
    t27 = *((int *)t26);
    t28 = (t27 - 7);
    t29 = (t28 * -1);
    t30 = (t29 * 32U);
    t31 = (t0 + 8520);
    t32 = *((int *)t31);
    t33 = (t32 - 31);
    t34 = (t33 * -1);
    t35 = (t30 + t34);
    t36 = (8U * t35);
    t37 = (0U + t36);
    t38 = (t0 + 3704);
    t39 = (t38 + 56U);
    t40 = *((char **)t39);
    t41 = (t40 + 56U);
    t42 = *((char **)t41);
    memcpy(t42, t25, 8U);
    xsi_driver_first_trans_delta(t38, t37, 8U, 0LL);

LAB17:    t2 = (t0 + 8520);
    t16 = *((int *)t2);
    t4 = (t0 + 8524);
    t17 = *((int *)t4);
    if (t16 == t17)
        goto LAB18;

LAB19:    t9 = (t16 + 1);
    t16 = t9;
    t5 = (t0 + 8520);
    *((int *)t5) = t16;
    goto LAB15;

LAB21:    xsi_set_current_line(56, ng0);
    t2 = (t0 + 1352U);
    t5 = *((char **)t2);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    if (t7 != 0)
        goto LAB24;

LAB26:    xsi_set_current_line(61, ng0);
    t2 = (t0 + 1992U);
    t4 = *((char **)t2);
    t2 = (t0 + 1192U);
    t5 = *((char **)t2);
    t29 = (15 - 7);
    t30 = (t29 * 1U);
    t34 = (0 + t30);
    t2 = (t5 + t34);
    t8 = (t18 + 0U);
    t11 = (t8 + 0U);
    *((int *)t11) = 7;
    t11 = (t8 + 4U);
    *((int *)t11) = 5;
    t11 = (t8 + 8U);
    *((int *)t11) = -1;
    t9 = (5 - 7);
    t35 = (t9 * -1);
    t35 = (t35 + 1);
    t11 = (t8 + 12U);
    *((unsigned int *)t11) = t35;
    t12 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t2, t18);
    t13 = (t12 - 7);
    t35 = (t13 * -1);
    xsi_vhdl_check_range_of_index(7, 0, -1, t12);
    t36 = (t35 * 32U);
    t11 = (t0 + 1192U);
    t14 = *((char **)t11);
    t37 = (15 - 4);
    t43 = (t37 * 1U);
    t44 = (0 + t43);
    t11 = (t14 + t44);
    t15 = (t45 + 0U);
    t19 = (t15 + 0U);
    *((int *)t19) = 4;
    t19 = (t15 + 4U);
    *((int *)t19) = 0;
    t19 = (t15 + 8U);
    *((int *)t19) = -1;
    t16 = (0 - 4);
    t46 = (t16 * -1);
    t46 = (t46 + 1);
    t19 = (t15 + 12U);
    *((unsigned int *)t19) = t46;
    t17 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t11, t45);
    t20 = (t17 - 31);
    t46 = (t20 * -1);
    xsi_vhdl_check_range_of_index(31, 0, -1, t17);
    t47 = (t36 + t46);
    t48 = (8U * t47);
    t49 = (0 + t48);
    t19 = (t4 + t49);
    t22 = (t0 + 3832);
    t25 = (t22 + 56U);
    t26 = *((char **)t25);
    t31 = (t26 + 56U);
    t38 = *((char **)t31);
    memcpy(t38, t19, 8U);
    xsi_driver_first_trans_fast_port(t22);

LAB25:    goto LAB22;

LAB24:    xsi_set_current_line(58, ng0);
    t2 = (t0 + 1672U);
    t8 = *((char **)t2);
    t2 = (t0 + 1192U);
    t11 = *((char **)t2);
    t29 = (15 - 7);
    t30 = (t29 * 1U);
    t34 = (0 + t30);
    t2 = (t11 + t34);
    t14 = (t18 + 0U);
    t15 = (t14 + 0U);
    *((int *)t15) = 7;
    t15 = (t14 + 4U);
    *((int *)t15) = 5;
    t15 = (t14 + 8U);
    *((int *)t15) = -1;
    t9 = (5 - 7);
    t35 = (t9 * -1);
    t35 = (t35 + 1);
    t15 = (t14 + 12U);
    *((unsigned int *)t15) = t35;
    t12 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t2, t18);
    t13 = (t12 - 7);
    t35 = (t13 * -1);
    t36 = (t35 * 32U);
    t15 = (t0 + 1192U);
    t19 = *((char **)t15);
    t37 = (15 - 4);
    t43 = (t37 * 1U);
    t44 = (0 + t43);
    t15 = (t19 + t44);
    t22 = (t45 + 0U);
    t25 = (t22 + 0U);
    *((int *)t25) = 4;
    t25 = (t22 + 4U);
    *((int *)t25) = 0;
    t25 = (t22 + 8U);
    *((int *)t25) = -1;
    t16 = (0 - 4);
    t46 = (t16 * -1);
    t46 = (t46 + 1);
    t25 = (t22 + 12U);
    *((unsigned int *)t25) = t46;
    t17 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t15, t45);
    t20 = (t17 - 31);
    t46 = (t20 * -1);
    t47 = (t36 + t46);
    t48 = (8U * t47);
    t49 = (0U + t48);
    t25 = (t0 + 3704);
    t26 = (t25 + 56U);
    t31 = *((char **)t26);
    t38 = (t31 + 56U);
    t39 = *((char **)t38);
    memcpy(t39, t8, 8U);
    xsi_driver_first_trans_delta(t25, t49, 8U, 0LL);
    goto LAB25;

}


extern void work_a_2696732300_3212880686_init()
{
	static char *pe[] = {(void *)work_a_2696732300_3212880686_p_0};
	xsi_register_didat("work_a_2696732300_3212880686", "isim/CacheSystem_tb_7_isim_beh.exe.sim/work/a_2696732300_3212880686.didat");
	xsi_register_executes(pe);
}
