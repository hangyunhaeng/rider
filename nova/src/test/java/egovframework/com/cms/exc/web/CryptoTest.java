package egovframework.com.cms.exc.web;
import kr.co.dozn.secure.base.CryptoUtil;

public class CryptoTest {

  private static final String key = "f657a924f4db69f7";
  private static final String iv = "4a9acfb04bf38a5b";

  public static void main(String[] args) {

    CryptoUtil cryptoUtil = CryptoUtil.getInstance(key, iv);
    /*예금주조회*/
    String encrypt = cryptoUtil.encrypt("{\n"
        + "    \"api_key\": \"b83ad316-be64-4c69-a8da-25177d307b2a\",\n"
        + "    \"org_code\": \"10000311\",\n"
        + "    \"telegram_no\": \"950998\",\n"
        + "    \"bank_code\": \"011\",\n"
        + "    \"account\": \"36701006302\",\n"
        + "    \"amount\": \"1\"\n"
        + "}");
    System.out.println("예금주조회 암호화 CODE: " + encrypt);

    encrypt ="ZF563HUd5d3s3j3bbeLJZAvowvVRx/IekjP+XAraonAOMyAiQ4WC4oEcGNL/nqwcjnjGBnbODpF5O+SCVP6FRpAXfHhdA1eqMjiiLWDk3ULru/m75V5E+GSL8H3HeaTDf0r7+76Yg2lue889cgDE5vRwrooX40kiddNq+fDAFpsl8N680+tC+RiFcvhAkH36hLwuBK+0XU6sem0ek8IOijU1I6Gd/QuN05jXGdzbrukMeoJLKprXkrzir8MzbOQv";

    String decrypt = cryptoUtil.decrypt(encrypt);
    System.out.println("예금주조회 복호화 CODE: " + decrypt);

    /*점유인증*/
    encrypt = cryptoUtil.encrypt("{\n"
                                            + "    \"api_key\": \"b83ad316-be64-4c69-a8da-25177d307b2a\",\n"
                                            + "    \"org_code\": \"10000311\",\n"
                                            + "    \"telegram_no\": \"950899\",\n"
                                            + "    \"rv_bank_code\": \"088\",\n"
                                            + "    \"rv_account\": \"140012036898\",\n"
                                            + "    \"rv_account_cntn\": \"당나귀다\",\n"
                                            + "    \"amount\": \"1\"\n"
                                            + "}");

    System.out.println("점유인증 암호화 CODE: " + encrypt);

    encrypt ="ZF563HUd5d3s3j3bbeLJZAvowvVRx/IekjP+XAraonAOMyAiQ4WC4oEcGNL/nqwcjnjGBnbODpF5O+SCVP6FRpAXfHhdA1eqMjiiLWDk3ULru/m75V5E+GSL8H3HeaTDY3MzJsdQlU3NKC4K5s5jjGl7qfIZ2XcQ0VOfm9j4EWZPodTv6y1Fwj/x2HA6ba4pTI+fEJKlH3LivrDi7H9Ri46fAtefeUsX/oruQM0UfR0F8UC+oz0uvV7nHwwDlBqzhHONwa6RSiZaMkLX2/YCrwSjewVNOnJI34ERD24T8sG7vlVNE6Ry616z6eqS+JcN";

    decrypt = cryptoUtil.decrypt(encrypt);
    System.out.println("점유인증 복호화 CODE: " + decrypt);

  }
}
