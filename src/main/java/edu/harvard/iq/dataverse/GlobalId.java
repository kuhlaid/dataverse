/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package edu.harvard.iq.dataverse;

import edu.harvard.iq.dataverse.settings.SettingsServiceBean;
import java.net.MalformedURLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.net.URL;
import javax.ejb.EJB;

/**
 *
 * @author skraffmiller
 */
public class GlobalId implements java.io.Serializable {

    @EJB
    SettingsServiceBean settingsService;

    public GlobalId(String identifier) {
        
        // set the protocol, authority, and identifier via parsePersistentId        
        if (!this.parsePersistentId(identifier)){
            throw new IllegalArgumentException("Failed to parse identifier: " + identifier);
        }
    }

    public GlobalId(String protocol, String authority, String identifier) {
        this.protocol = protocol;
        this.authority = authority;
        this.identifier = identifier;
    }

    private String protocol;
    private String authority;
    private String identifier;

    public String getProtocol() {
        return protocol;
    }

    public void setProtocol(String protocol) {
        this.protocol = protocol;
    }

    public String getAuthority() {
        return authority;
    }

    public void setAuthority(String authority) {
        this.authority = authority;
    }

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public String toString() {
        return protocol + ":" + authority + "/" + identifier;
    }
    
    public URL toURL() {
        URL url = null;
        try {
            if (protocol.equals("doi")){
               url = new URL("http://dx.doi.org/" + authority + "/" + identifier); 
            } else {
               url = new URL("http://hdl.handle.net/" + authority + "/" + identifier);  
            }           
        } catch (MalformedURLException ex) {
            Logger.getLogger(GlobalId.class.getName()).log(Level.SEVERE, null, ex);
        }       
        return url;
    }    

    
    /** 
     *   Parse a Persistent Id and set the protocol, authority, and identifier
     * 
     *   Example 1: doi:10.5072/FK2/BYM3IW
     *       protocol: doi
     *       authority: 10.5072/FK2
     *       identifier: BYM3IW
     * 
     *   Example 2: hdl:1902.1/111012
     *       protocol: hdl
     *       authority: 1902.1
     *       identifier: 111012
     *
     * @param persistentId
     * 
     */
    private boolean parsePersistentId(String persistentId){

        if (persistentId==null){
            return false;
        } 
        
        String doiSeparator = "/";//settingsService.getValueForKey(SettingsServiceBean.Key.DoiSeparator, "/");
        
        // Looking for this split  
        //  doi:10.5072/FK2/BYM3IW => (doi) (10.5072/FK2/BYM3IW)
        //
        //  or this one: hdl:1902.1/xxxxx
        //
        String[] items = persistentId.split(":");
        if (items.length != 2){
            return false;
        }
        String protocolPiece = items[0].toLowerCase();
        
        String[] pieces = items[1].split(doiSeparator);

        // Is this a handle?
        if ( pieces.length == 2 && protocolPiece.equals("hdl")){
            
            this.protocol = protocolPiece;
            this.authority = pieces[0];
            this.identifier = pieces[1];                    
            return true;
                    
        }else if (pieces.length == 3 && protocolPiece.equals("doi")){
        
            this.protocol = protocolPiece;
            this.authority = pieces[0] + doiSeparator + pieces[1]; // "10.5072/FK2"
            this.identifier = pieces[2]; // "BYM3IW"
            return true;
        }
        
        return false;
    }

    
    
}
