<?php

/*
 * Copyright (C) 2024 Deciso B.V.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

namespace OPNsense\Auth\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Base\UserException;

/**
 * Class CertController
 * @package OPNsense\Auth\Api
 */
class UserController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'user';
    protected static $internalModelClass = 'OPNsense\Auth\User';

    public function searchAction()
    {
        return $this->searchBase('user');
    }

    public function getAction($uuid = null)
    {
        $result = $this->getBase('user', 'user', $uuid);
        $result['user']['otp_uri'] = '';
        if (!empty($result['user']['otp_seed'])) {
            $result['user']['otp_uri'] = sprintf(
                "otpauth://totp/%s@%s?secret=%s&issuer=OPNsense&image=https://docs.opnsense.org/_static/favicon.png",
                $result['user']['name'],
                'xxx',
                $result['user']['otp_seed']
            );
        }
        return $result;
    }

    public function addAction()
    {
        return $this->addBase('user', 'user');
    }

    public function setAction($uuid = null)
    {
        return $this->setBase('user', 'user', $uuid);
    }

    public function delAction($uuid)
    {
        return $this->delBase('user', $uuid);
    }

    public function searchApiKeyAction()
    {
        return $this->searchRecordsetBase($this->getModel()->getApiKeys());
    }

    public function delApiKeyAction($id)
    {
        /* id is a base64 encoded string, we need to encode 'key' to prevent mangling data in the request */
        $key = base64_decode($id);
        if ($key !== null && $this->request->isPost()) {
            $user = $this->getModel()->getUserByApiKey($key);
            if ($user !== null) {
                $user->apikeys->del($key);
                $this->save(false, true);
                return ['result' => 'deleted'];
            } else {
                return ['result' => 'not found'];
            }
        }
        return ["result" => "failed"];
    }

}
